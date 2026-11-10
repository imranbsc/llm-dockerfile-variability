"""
Step 6 - check every generated Dockerfile with hadolint and Checkov.

    python lint_all.py           the full experiment  (data/ -> results/)
    python lint_all.py --pilot   the pilot            (data_pilot/ -> results_pilot/)

It starts from scratch every time and overwrites its result files, so you can
run it as often as you like, for example after  python generate.py --reextract.

Result files:
    results/files.csv              one row per answer: smell counts and more
    results/hadolint_findings.csv  one row per hadolint finding
    results/checkov_findings.csv   one row per failed Checkov check
    results/lint_tools.json        tool versions and options, for your Methodology
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import helpers

FILE_FIELDS = [
    "run_id", "model", "model_code", "prompt_id", "stack", "scenario", "temperature",
    "seed", "run", "done_reason", "output_tokens", "extraction",
    "has_dockerfile", "parse_ok", "hl_total", "hl_distinct", "hl_error", "hl_warning",
    "hl_info", "hl_style", "hl_rules", "ck_failed", "ck_checks", "ignore_pragma",
    "n_lines", "base_images", "norm_sha",
]
HADOLINT_FIELDS = ["run_id", "code", "level", "line", "column", "message"]
CHECKOV_FIELDS = ["run_id", "check_id", "check_name", "line_start", "line_end"]
PARSE_ERROR = "DL1000"   # hadolint's code for "this is not valid Dockerfile syntax"


def lint_hadolint(exe: str, runs: list[dict]) -> dict:
    """Run hadolint on every Dockerfile (4 at a time) and return {run_id: findings}."""
    def one(run):
        return run["run_id"], helpers.run_hadolint(exe, helpers.ROOT / run["dockerfile_file"])

    results = {}
    with ThreadPoolExecutor(max_workers=4) as pool:
        for i, (run_id, findings) in enumerate(pool.map(one, runs), 1):
            results[run_id] = findings
            if i % 100 == 0 or i == len(runs):
                print(f"   hadolint: {i}/{len(runs)} files")
    return results


def lint_checkov(folder: dict, runs: list[dict]) -> dict:
    """Scan the whole Dockerfile folder with Checkov; fall back to one file at a time."""
    wanted = {r["run_id"] for r in runs}
    print("   Checkov: scanning the folder (this can take a minute)...")
    try:
        failed = helpers.run_checkov(folder["dockerfiles"], is_dir=True)
    except Exception as error:  # noqa: BLE001
        print(f"   Checkov folder scan failed ({error}); scanning file by file instead (slower).")
        failed = []
        for i, run in enumerate(runs, 1):
            failed += helpers.run_checkov(helpers.ROOT / run["dockerfile_file"], is_dir=False)
            if i % 50 == 0 or i == len(runs):
                print(f"   Checkov: {i}/{len(runs)} files")
    results = {run_id: [] for run_id in wanted}
    for check in failed:
        run_id = check["file"].removesuffix(".Dockerfile")
        if run_id in results:
            results[run_id].append(check)
    return results


def summarise(run: dict, hadolint: list[dict] | None, checkov: list[dict] | None) -> dict:
    row = {key: run.get(key, "") for key in FILE_FIELDS}
    if not run["dockerfile_file"]:
        row.update(has_dockerfile=0)
        return row
    text = (helpers.ROOT / run["dockerfile_file"]).read_text(encoding="utf-8")
    normalized = helpers.normalize(text)
    findings = [f for f in hadolint if f.get("code") != PARSE_ERROR]
    levels = [f.get("level") for f in findings]
    codes = sorted({f.get("code") for f in findings})
    checks = sorted({c["check_id"] for c in checkov})
    row.update(
        has_dockerfile=1,
        parse_ok=0 if any(f.get("code") == PARSE_ERROR for f in hadolint) else 1,
        hl_total=len(findings), hl_distinct=len(codes),
        hl_error=levels.count("error"), hl_warning=levels.count("warning"),
        hl_info=levels.count("info"), hl_style=levels.count("style"),
        hl_rules=";".join(codes), ck_failed=len(checkov), ck_checks=";".join(checks),
        ignore_pragma=int("hadolint ignore" in text.lower()),
        n_lines=len(normalized.split("\n")) if normalized else 0,
        base_images="|".join(helpers.base_images(text)),
        norm_sha=helpers.sha256_text(normalized)[:16],
    )
    return row


def main() -> None:
    parser = argparse.ArgumentParser(description="Lint all generated Dockerfiles.")
    parser.add_argument("--pilot", action="store_true", help="lint the pilot data")
    args = parser.parse_args()
    folder = helpers.folders(args.pilot)

    runs = [r for r in helpers.read_csv(folder["runs_csv"]) if r.get("status") == "ok"]
    if not runs:
        sys.exit(f"No answers in {helpers.rel(folder['runs_csv'])} yet. Run generate.py first.")
    with_file = [r for r in runs if r["dockerfile_file"]]
    exe = helpers.find_hadolint()
    if exe is None:
        sys.exit("hadolint not found. Put hadolint.exe in this folder (guide, Step 3).")
    folder["results"].mkdir(parents=True, exist_ok=True)
    print(f"{len(runs)} answers, {len(with_file)} with a Dockerfile.")

    tools = {
        "date_utc": dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"),
        "hadolint": helpers.hadolint_version(exe),
        "hadolint_options": "--config hadolint.yaml --no-fail --disable-ignore-pragma --format json",
        "hadolint_config": (helpers.ROOT / "hadolint.yaml").read_text(encoding="utf-8"),
        "checkov": helpers.checkov_version(),
        "checkov_options": "--framework dockerfile -o json --quiet --skip-download",
    }
    print(f"Tools: {tools['hadolint']}; Checkov {tools['checkov']}")

    hadolint = lint_hadolint(exe, with_file)
    checkov = lint_checkov(folder, with_file)

    file_rows = [summarise(r, hadolint.get(r["run_id"]), checkov.get(r["run_id"])) for r in runs]
    hl_rows = [{"run_id": run_id, **{k: f.get(k, "") for k in HADOLINT_FIELDS[1:]}}
               for run_id, findings in hadolint.items() for f in findings]
    ck_rows = [{"run_id": run_id, **{k: c.get(k, "") for k in CHECKOV_FIELDS[1:]}}
               for run_id, checks in checkov.items() for c in checks]

    out = folder["results"]
    helpers.write_csv(out / "files.csv", FILE_FIELDS, file_rows)
    helpers.write_csv(out / "hadolint_findings.csv", HADOLINT_FIELDS, hl_rows)
    helpers.write_csv(out / "checkov_findings.csv", CHECKOV_FIELDS, ck_rows)
    Path(out / "lint_tools.json").write_text(json.dumps(tools, indent=2), encoding="utf-8")

    n_parse = sum(1 for r in file_rows if r.get("parse_ok") == 0)
    print(f"\nSaved {helpers.rel(out / 'files.csv')} ({len(file_rows)} rows), "
          f"{len(hl_rows)} hadolint findings, {len(ck_rows)} failed Checkov checks.")
    print(f"Answers without a Dockerfile: {len(runs) - len(with_file)}; "
          f"Dockerfiles hadolint could not parse ({PARSE_ERROR}): {n_parse}.")
    print("Next step:  python analyze.py" + (" --pilot" if args.pilot else ""))


if __name__ == "__main__":
    main()
