"""
Shared code used by generate.py, lint_all.py and analyze.py.
You never run this file yourself.
"""

from __future__ import annotations

import csv
import difflib
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent

# Columns of data/runs.csv: one row per answer the model gave.
RUN_FIELDS = [
    "run_id", "timestamp_utc", "model", "model_code", "model_digest",
    "prompt_id", "stack", "scenario", "temperature", "seed", "run",
    "num_ctx", "num_predict", "done_reason", "prompt_tokens", "output_tokens",
    "total_s", "load_s", "generation_s", "tokens_per_s",
    "extraction", "n_code_blocks", "raw_file", "dockerfile_file",
    "status", "error",
]


# ---------------------------------------------------------------------------
# Folders
# ---------------------------------------------------------------------------
def folders(pilot: bool) -> dict:
    """Where the data and results of the pilot or the full run live."""
    data = ROOT / ("data_pilot" if pilot else "data")
    results = ROOT / ("results_pilot" if pilot else "results")
    return {
        "data": data,
        "raw": data / "raw",
        "dockerfiles": data / "dockerfiles",
        "models": data / "models",
        "runs_csv": data / "runs.csv",
        "results": results,
        "tables": results / "tables",
        "figures": results / "figures",
    }


def make_run_id(model_code: str, prompt_id: str, temperature: float, run: int) -> str:
    """For example q7b__P01__T0.8__R03 (safe as a Windows file name)."""
    return f"{model_code}__{prompt_id}__T{temperature:.1f}__R{run:02d}"


def rel(path: Path) -> str:
    """Path relative to the project folder, written with / so it works everywhere."""
    return Path(path).resolve().relative_to(ROOT).as_posix()


# ---------------------------------------------------------------------------
# CSV files
# ---------------------------------------------------------------------------
def read_csv(path: Path) -> list[dict]:
    if not Path(path).exists():
        return []
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def append_row(path: Path, fields: list[str], row: dict) -> None:
    """Add one row and close the file at once, so a crash never loses finished work."""
    path = Path(path)
    new_file = not path.exists() or path.stat().st_size == 0
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "a", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        if new_file:
            writer.writeheader()
        writer.writerow(row)


def write_csv(path: Path, fields: list[str], rows: list[dict]) -> None:
    """Write a whole CSV safely: first to a temporary file, then swap it in."""
    path = Path(path)
    tmp = path.with_suffix(path.suffix + ".tmp")
    with open(tmp, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)
    os.replace(tmp, path)


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


# ---------------------------------------------------------------------------
# Cutting the Dockerfile out of the model's answer
# ---------------------------------------------------------------------------
FENCE_RE = re.compile(r"```[ \t]*([^\n`]*)\n(.*?)```", re.DOTALL)
FROM_RE = re.compile(r"^\s*FROM\s+\S", re.IGNORECASE | re.MULTILINE)
DOCKER_LABELS = {"dockerfile", "docker", "containerfile"}


def _tidy(text: str) -> str:
    text = text.replace("\r\n", "\n").strip("\n")
    return text + "\n" if text else ""


def extract_dockerfile(answer: str) -> tuple[str, str, int]:
    """
    Return (dockerfile_text, method, number_of_code_blocks).

    Rules, tried in this order:
      1. fenced_label   the first ``` block labelled dockerfile/docker
      2. fenced_from    the first ``` block that contains a FROM line
      3. unclosed_fence the answer was cut off inside a ``` block with a FROM line
      4. no_fence       no ``` at all, but the answer contains a FROM line
      5. not_found      nothing that looks like a Dockerfile
    """
    text = answer.replace("\r\n", "\n")
    blocks = FENCE_RE.findall(text)
    for label, body in blocks:
        words = label.strip().lower().split()
        if words and words[0] in DOCKER_LABELS and body.strip():
            return _tidy(body), "fenced_label", len(blocks)
    for _label, body in blocks:
        if FROM_RE.search(body):
            return _tidy(body), "fenced_from", len(blocks)
    if text.count("```") % 2 == 1:  # one fence was opened but never closed
        tail = text[text.rfind("```") + 3:]
        newline = tail.find("\n")
        body = tail[newline + 1:] if newline != -1 else ""
        if FROM_RE.search(body):
            return _tidy(body), "unclosed_fence", len(blocks)
    if "```" not in text and FROM_RE.search(text):
        return _tidy(text), "no_fence", 0
    return "", "not_found", len(blocks)


# ---------------------------------------------------------------------------
# Comparing Dockerfiles
# ---------------------------------------------------------------------------
def normalize(dockerfile: str) -> str:
    """
    The version of a Dockerfile used to compare runs: comment lines and blank
    lines removed, continuation lines (ending in a backslash) joined, runs of
    spaces collapsed. Two files that differ only in comments or layout give
    the same normalized text.
    """
    kept = []
    for line in dockerfile.replace("\r\n", "\n").split("\n"):
        if line.strip().startswith("#"):
            continue
        kept.append(line)
    joined = re.sub(r"\\[ \t]*\n", " ", "\n".join(kept))
    lines = [" ".join(line.split()) for line in joined.split("\n")]
    return "\n".join(line for line in lines if line)


def base_images(dockerfile: str) -> list[str]:
    """Images named in FROM lines, leaving out references to earlier build stages."""
    images, aliases = [], set()
    for line in normalize(dockerfile).split("\n"):
        parts = line.split()
        if not parts or parts[0].upper() != "FROM":
            continue
        args = [p for p in parts[1:] if not p.startswith("--")]
        if not args:
            continue
        image = args[0]
        if image.lower() not in aliases:
            images.append(image)
        if len(args) >= 3 and args[1].upper() == "AS":
            aliases.add(args[2].lower())
    return images


def similarity(a: str, b: str) -> float:
    """Share of matching lines between two normalized Dockerfiles, 0 to 1
    (Python difflib, based on Ratcliff/Obershelp pattern matching)."""
    return difflib.SequenceMatcher(None, a.split("\n"), b.split("\n"), autojunk=False).ratio()


# ---------------------------------------------------------------------------
# Tools: Ollama, hadolint, Checkov
# ---------------------------------------------------------------------------
def ollama_server_version(host: str) -> str:
    with urllib.request.urlopen(host.rstrip("/") + "/api/version", timeout=10) as r:
        return json.loads(r.read().decode("utf-8")).get("version", "?")


def find_hadolint() -> str | None:
    """hadolint.exe in this folder wins; otherwise any hadolint on the PATH."""
    for name in ("hadolint.exe", "hadolint"):
        local = ROOT / name
        if local.is_file():
            return str(local)
    return shutil.which("hadolint")


def _run(cmd: list[str], timeout: int = 600) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8",
                          errors="replace", timeout=timeout)


def hadolint_version(exe: str) -> str:
    return _run([exe, "--version"]).stdout.strip()


def run_hadolint(exe: str, dockerfile: Path) -> list[dict]:
    """
    Lint one Dockerfile and return hadolint's findings as a list of dicts with
    the keys code, level, line, column, message.
      --config hadolint.yaml   our settings: every rule on, nothing ignored
      --no-fail                exit code 0 even when smells are found
      --disable-ignore-pragma  "# hadolint ignore=..." comments written by
                               the model cannot hide smells
      --format json            output that Python can read
    """
    cmd = [exe, "--config", str(ROOT / "hadolint.yaml"), "--no-fail",
           "--disable-ignore-pragma", "--format", "json", str(dockerfile)]
    result = _run(cmd, timeout=120)
    out = result.stdout.strip()
    if not out:
        if result.returncode != 0:
            raise RuntimeError(f"hadolint failed on {dockerfile}: {result.stderr.strip()[:300]}")
        return []
    return json.loads(out)


def _loose_json(text: str):
    """Parse JSON even if a tool printed a stray line before it."""
    text = text.strip()
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        starts = [i for i in (text.find("["), text.find("{")) if i != -1]
        if not starts:
            raise
        obj, _end = json.JSONDecoder().raw_decode(text[min(starts):])
        return obj


def checkov_cmd() -> list[str]:
    """Start Checkov through the current Python, which works the same on Windows."""
    return [sys.executable, "-m", "checkov.main"]


def checkov_version() -> str:
    return _run(checkov_cmd() + ["--version"], timeout=180).stdout.strip()


def run_checkov(target: Path, is_dir: bool) -> list[dict]:
    """
    Scan a Dockerfile (or a folder of *.Dockerfile files) with Checkov and
    return the failed checks: check_id, check_name, file, line_start, line_end.
      --framework dockerfile  only the Dockerfile checks
      --quiet                 report only failed checks
      --skip-download         work offline, no calls to the vendor's servers
    """
    cmd = checkov_cmd() + ["-d" if is_dir else "-f", str(target), "--framework",
                           "dockerfile", "-o", "json", "--quiet", "--skip-download"]
    result = _run(cmd, timeout=3600)
    if not result.stdout.strip():
        raise RuntimeError(f"Checkov printed nothing. Error output: {result.stderr.strip()[:500]}")
    data = _loose_json(result.stdout)
    reports = data if isinstance(data, list) else [data]
    failed = []
    for report in reports:
        if not isinstance(report, dict):
            continue
        for check in report.get("results", {}).get("failed_checks", []):
            lines = check.get("file_line_range") or [None, None]
            failed.append({
                "check_id": check.get("check_id", ""),
                "check_name": check.get("check_name", ""),
                "file": os.path.basename(str(check.get("file_path", "")).replace("\\", "/")),
                "line_start": lines[0],
                "line_end": lines[-1],
            })
    return failed
