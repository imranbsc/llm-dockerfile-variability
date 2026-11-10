"""
Step 5 - ask Qwen for Dockerfiles and save every answer.

Run these in PowerShell, inside C:\\dockerfile-study, with (.venv) active:

    python generate.py --show-prompts   print the 30 prompts exactly as they are sent
    python generate.py --pilot          small test run, then a pilot report
    python generate.py                  the full experiment (hours; safe to stop and restart)
    python generate.py --model q7b      only one model, for example one model per night
    python generate.py --status         how many answers are done and how many are left
    python generate.py --reextract      cut the Dockerfiles out of the saved answers again
    python generate.py --sample 20      pick 20 random answers to check the extraction by eye

Nothing is ever deleted. When you start the script again, finished runs are
skipped and it continues where it stopped.
"""

from __future__ import annotations

import argparse
import datetime as dt
import importlib.metadata as metadata
import json
import platform
import sys
import time

import config
import helpers


# ---------------------------------------------------------------------------
# Prompts and the list of runs
# ---------------------------------------------------------------------------
def load_prompts() -> list[dict]:
    rows = helpers.read_csv(helpers.ROOT / "prompts.csv")
    needed = {"prompt_id", "stack", "scenario", "app"}
    if not rows or not needed <= set(rows[0]):
        sys.exit("prompts.csv must have the columns prompt_id, stack, scenario, app.")
    ids = [r["prompt_id"] for r in rows]
    if len(ids) != len(set(ids)):
        sys.exit("prompts.csv contains the same prompt_id twice.")
    for r in rows:
        r["prompt"] = config.PROMPT_TEMPLATE.format(app=r["app"].strip())
    return rows


def build_jobs(prompts: list[dict], pilot: bool, only_models: list[str]) -> list[dict]:
    runs_per_temperature = config.PILOT_RUNS_PER_TEMPERATURE if pilot else config.RUNS_PER_TEMPERATURE
    if pilot:
        prompts = [p for p in prompts if p["prompt_id"] in config.PILOT_PROMPTS]
    jobs = []
    for model, code in config.MODELS.items():
        if only_models and code not in only_models:
            continue
        for p in prompts:
            for temperature, n_runs in runs_per_temperature.items():
                for run in range(1, n_runs + 1):
                    jobs.append({
                        "run_id": helpers.make_run_id(code, p["prompt_id"], temperature, run),
                        "model": model, "model_code": code,
                        "prompt_id": p["prompt_id"], "stack": p["stack"], "scenario": p["scenario"],
                        "prompt": p["prompt"], "temperature": temperature,
                        "seed": config.SEED_START + run - 1, "run": run,
                    })
    return jobs


# ---------------------------------------------------------------------------
# Protection against changing the experiment halfway
# ---------------------------------------------------------------------------
FIXED_SETTINGS = ("prompt_template", "prompts", "seed_start", "num_ctx", "num_predict")


def current_settings(prompts: list[dict]) -> dict:
    return {
        "prompt_template": config.PROMPT_TEMPLATE,
        "prompts": {p["prompt_id"]: p["prompt"] for p in prompts},
        "seed_start": config.SEED_START,
        "num_ctx": config.NUM_CTX,
        "num_predict": config.NUM_PREDICT,
        "models": config.MODELS,
        "runs_per_temperature": {str(k): v for k, v in config.RUNS_PER_TEMPERATURE.items()},
        "pilot_runs_per_temperature": {str(k): v for k, v in config.PILOT_RUNS_PER_TEMPERATURE.items()},
    }


def check_settings(folder: dict, settings: dict) -> None:
    path = folder["data"] / "settings.json"
    if path.exists():
        saved = json.loads(path.read_text(encoding="utf-8"))
        changed = [key for key in FIXED_SETTINGS if saved.get(key) != settings.get(key)]
        if changed:
            sys.exit(
                "STOP: these settings differ from the ones used for the data already in "
                f"{helpers.rel(folder['data'])}: {', '.join(changed)}.\n"
                "Mixing them would make the data incomparable. Either undo the change in "
                "config.py / prompts.csv, or rename the data folder (for example to "
                "data_old) and start a new run."
            )
    folder["data"].mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(settings, indent=2), encoding="utf-8")


# ---------------------------------------------------------------------------
# Talking to Ollama
# ---------------------------------------------------------------------------
def connect():
    import ollama
    try:
        version = helpers.ollama_server_version(config.OLLAMA_HOST)
    except Exception:  # noqa: BLE001
        sys.exit(f"Ollama does not answer at {config.OLLAMA_HOST}. Start Ollama from the "
                 "Start menu (llama icon near the clock) and try again.")
    client = ollama.Client(host=config.OLLAMA_HOST, timeout=config.REQUEST_TIMEOUT_S)
    return client, version


def record_models(client, folder: dict, model_names: list[str], allow_change: bool) -> dict:
    """Save each model's digest and default settings; stop if a model file changed."""
    installed = {m.model: (m.digest or "") for m in client.list().models}
    missing = [m for m in model_names if m not in installed]
    if missing:
        sys.exit("These models are not downloaded yet:\n" +
                 "\n".join(f"   ollama pull {m}" for m in missing))
    folder["models"].mkdir(parents=True, exist_ok=True)
    digests = {}
    for name in model_names:
        code = config.MODELS[name]
        path = folder["models"] / f"{code}.json"
        digest = installed[name]
        if path.exists() and not allow_change:
            old = json.loads(path.read_text(encoding="utf-8")).get("digest")
            if old and old != digest:
                sys.exit(f"STOP: the model file of {name} changed since the first run "
                         f"(ID {old[:12]} -> {digest[:12]}). Data from two different model "
                         "files must not be mixed. Ask for help before continuing.")
        info = client.show(name)
        path.write_text(json.dumps({
            "model": name, "digest": digest,
            "details": info.details.model_dump(mode="json") if info.details else None,
            "parameters": info.parameters, "template": info.template,
            "capabilities": info.capabilities,
            "modified_at": str(info.modified_at) if info.modified_at else None,
        }, indent=2), encoding="utf-8")
        digests[name] = digest
    return digests


def log_session(folder: dict, ollama_version: str, digests: dict, n_todo: int) -> None:
    versions = {}
    for package in ("ollama", "pandas", "scipy", "matplotlib", "checkov"):
        try:
            versions[package] = metadata.version(package)
        except metadata.PackageNotFoundError:
            versions[package] = None
    entry = {
        "started_utc": dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"),
        "ollama_server_version": ollama_version,
        "python": platform.python_version(),
        "platform": platform.platform(),
        "processor": platform.processor(),
        "packages": versions,
        "model_digests": {name: d[:12] for name, d in digests.items()},
        "runs_to_do": n_todo,
    }
    with open(folder["data"] / "sessions.jsonl", "a", encoding="utf-8") as f:
        f.write(json.dumps(entry) + "\n")


def run_one(client, job: dict, folder: dict, digest: str) -> dict:
    """Ask the model once, save the answer and the Dockerfile, return the runs.csv row."""
    row = {key: job[key] for key in ("run_id", "model", "model_code", "prompt_id", "stack",
                                     "scenario", "temperature", "seed", "run")}
    row.update(timestamp_utc=dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"),
               model_digest=digest[:12], num_ctx=config.NUM_CTX, num_predict=config.NUM_PREDICT)
    try:
        response = client.chat(
            model=job["model"],
            messages=[{"role": "user", "content": job["prompt"]}],
            options={"temperature": job["temperature"], "seed": job["seed"],
                     "num_ctx": config.NUM_CTX, "num_predict": config.NUM_PREDICT},
            keep_alive=config.KEEP_ALIVE,
        )
    except Exception as error:  # noqa: BLE001 - every failure is recorded, then retried later
        row.update(status="error", error=f"{type(error).__name__}: {error}"[:300])
        return row

    answer = response.message.content or ""
    raw_path = folder["raw"] / f"{job['run_id']}.md"
    raw_path.write_text(answer, encoding="utf-8", newline="")
    dockerfile, method, n_blocks = helpers.extract_dockerfile(answer)
    dockerfile_path = folder["dockerfiles"] / f"{job['run_id']}.Dockerfile"
    if dockerfile:
        dockerfile_path.write_text(dockerfile, encoding="utf-8", newline="\n")

    def seconds(ns):
        return round(ns / 1e9, 3) if ns else ""

    rate = ""
    if response.eval_count and response.eval_duration:
        rate = round(response.eval_count / (response.eval_duration / 1e9), 2)
    row.update(
        done_reason=response.done_reason or "", prompt_tokens=response.prompt_eval_count or "",
        output_tokens=response.eval_count or "", total_s=seconds(response.total_duration),
        load_s=seconds(response.load_duration), generation_s=seconds(response.eval_duration),
        tokens_per_s=rate, extraction=method, n_code_blocks=n_blocks,
        raw_file=helpers.rel(raw_path),
        dockerfile_file=helpers.rel(dockerfile_path) if dockerfile else "",
        status="ok", error="",
    )
    return row


# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------
def finished_ids(folder: dict) -> set[str]:
    return {r["run_id"] for r in helpers.read_csv(folder["runs_csv"]) if r.get("status") == "ok"}


def show_prompts(prompts: list[dict]) -> None:
    for p in prompts:
        print(f"{p['prompt_id']}  [{p['stack']} | {p['scenario']}]\n    {p['prompt']}\n")
    print(f"{len(prompts)} prompts.")


def show_status(jobs: list[dict], folder: dict) -> None:
    done = finished_ids(folder)
    rows = helpers.read_csv(folder["runs_csv"])
    errors = sum(1 for r in rows if r.get("status") == "error" and r["run_id"] not in done)
    print(f"Data folder: {helpers.rel(folder['data'])}")
    print(f"{'model':8} {'temp':>5} {'done':>6} {'planned':>8}")
    for code in sorted({j["model_code"] for j in jobs}):
        for temperature in sorted({j["temperature"] for j in jobs}):
            planned = [j for j in jobs if j["model_code"] == code and j["temperature"] == temperature]
            n_done = sum(1 for j in planned if j["run_id"] in done)
            print(f"{code:8} {temperature:>5} {n_done:>6} {len(planned):>8}")
    total_done = sum(1 for j in jobs if j["run_id"] in done)
    print(f"\nTotal: {total_done} of {len(jobs)} answers done; {errors} failed run(s) will be retried.")


def reextract(folder: dict) -> None:
    rows = helpers.read_csv(folder["runs_csv"])
    if not rows:
        sys.exit("No runs.csv yet - nothing to re-extract.")
    changed = 0
    for row in rows:
        if row.get("status") != "ok":
            continue
        answer = (helpers.ROOT / row["raw_file"]).read_text(encoding="utf-8")
        dockerfile, method, n_blocks = helpers.extract_dockerfile(answer)
        path = folder["dockerfiles"] / f"{row['run_id']}.Dockerfile"
        if dockerfile:
            path.write_text(dockerfile, encoding="utf-8", newline="\n")
        elif path.exists():
            path.unlink()
        if row.get("extraction") != method:
            changed += 1
        row.update(extraction=method, n_code_blocks=n_blocks,
                   dockerfile_file=helpers.rel(path) if dockerfile else "")
    helpers.write_csv(folder["runs_csv"], helpers.RUN_FIELDS, rows)
    print(f"Re-extracted {len(rows)} answers; the extraction method changed for {changed}.")


def sample(folder: dict, n: int) -> None:
    """Pick n random answers (always the same ones) to compare with their Dockerfiles."""
    import random
    rows = [r for r in helpers.read_csv(folder["runs_csv"]) if r.get("status") == "ok"]
    if not rows:
        sys.exit("No answers yet.")
    picked = sorted(random.Random(2026).sample(rows, min(n, len(rows))), key=lambda r: r["run_id"])
    print(f"Open each answer next to its Dockerfile and check that the cut is right:\n")
    for r in picked:
        print(f"{r['run_id']:26} {r['extraction']:15} {r['raw_file']}")
        print(f"{'':26} {'':15} {r['dockerfile_file'] or '(no Dockerfile found)'}")
    print(f"\n{len(picked)} answers. Note how many were cut correctly; report it in your paper.")


def generate(jobs: list[dict], folder: dict, allow_model_change: bool) -> None:
    done = finished_ids(folder)
    todo = [j for j in jobs if j["run_id"] not in done]
    print(f"{len(jobs)} answers planned, {len(jobs) - len(todo)} already done, {len(todo)} to go.")
    if not todo:
        return
    client, ollama_version = connect()
    model_names = sorted({j["model"] for j in todo}, key=list(config.MODELS).index)
    digests = record_models(client, folder, model_names, allow_model_change)
    log_session(folder, ollama_version, digests, len(todo))
    for key in ("raw", "dockerfiles"):
        folder[key].mkdir(parents=True, exist_ok=True)
    print(f"Ollama {ollama_version}. Press Ctrl+C to stop at any time; run the same command to continue.\n")

    started, failures_in_a_row = time.time(), 0
    try:
        for i, job in enumerate(todo, 1):
            t0 = time.time()
            row = run_one(client, job, folder, digests[job["model"]])
            helpers.append_row(folder["runs_csv"], helpers.RUN_FIELDS, row)
            elapsed = time.time() - started
            eta_min = elapsed / i * (len(todo) - i) / 60
            if row["status"] == "ok":
                failures_in_a_row = 0
                print(f"[{i}/{len(todo)}] {job['run_id']}  {time.time() - t0:5.0f}s  "
                      f"{row['output_tokens']} tokens  {row['extraction']}  ~{eta_min:.0f} min left")
            else:
                failures_in_a_row += 1
                print(f"[{i}/{len(todo)}] {job['run_id']}  FAILED: {row['error']}")
                if failures_in_a_row >= 3:
                    sys.exit("Three failures in a row - is Ollama still running? "
                             "Start it, then run the same command again to continue.")
    except KeyboardInterrupt:
        sys.exit("\nStopped (Ctrl+C). Everything finished so far is saved. "
                 "Run the same command again to continue.")
    print(f"\nDone: {len(todo)} answers in {(time.time() - started) / 60:.0f} minutes.")


def pilot_report(folder: dict) -> None:
    """Summarise the pilot: does T=0 repeat, how much does T=0.8 vary, how long will it take."""
    import pandas as pd
    df = pd.DataFrame(helpers.read_csv(folder["runs_csv"]))
    if df.empty:
        return
    df = df[df["status"] == "ok"].copy()
    for col in ("temperature", "total_s", "output_tokens", "tokens_per_s"):
        df[col] = pd.to_numeric(df[col], errors="coerce")

    def texts(group, kind):
        out = []
        for _, r in group.iterrows():
            if kind == "raw":
                out.append((helpers.ROOT / r["raw_file"]).read_text(encoding="utf-8"))
            elif r["dockerfile_file"]:
                out.append(helpers.normalize((helpers.ROOT / r["dockerfile_file"]).read_text(encoding="utf-8")))
            else:
                out.append("<no Dockerfile>")
        return out

    lines = ["PILOT REPORT", "=" * 60, ""]
    for temperature, title in ((0.0, "1. Temperature 0: does the model repeat itself?"),
                               (0.8, "2. Temperature 0.8: how different are the answers?")):
        lines += [title, f"   {'model':7} {'prompt':6} {'runs':>4} {'different answers':>18} {'different Dockerfiles*':>23}"]
        part = df[df["temperature"] == temperature]
        all_same = True
        for (code, prompt), group in part.groupby(["model_code", "prompt_id"], sort=True):
            n_raw, n_norm = len(set(texts(group, "raw"))), len(set(texts(group, "norm")))
            all_same &= n_raw == 1
            lines.append(f"   {code:7} {prompt:6} {len(group):>4} {n_raw:>18} {n_norm:>23}")
        if temperature == 0.0 and len(part):
            verdict = "YES - every repeat was identical" if all_same else "NO - some repeats differ (report this!)"
            lines.append(f"   Identical at temperature 0: {verdict}")
        lines.append("")
    lines.append("   * after removing comments, blank lines and extra spaces")
    lines += ["", "3. Speed on this laptop",
              f"   {'model':7} {'answers':>7} {'median s':>9} {'median tokens':>14} {'tokens/s':>9}"]
    runs_per_prompt = sum(config.RUNS_PER_TEMPERATURE.values())
    full_per_model = config.FULL_PROMPT_COUNT * runs_per_prompt
    total_hours = 0.0
    estimates = []
    for code, group in df.groupby("model_code", sort=False):
        median_s = group["total_s"].median()
        lines.append(f"   {code:7} {len(group):>7} {median_s:>9.1f} {group['output_tokens'].median():>14.0f} "
                     f"{group['tokens_per_s'].median():>9.1f}")
        hours = median_s * full_per_model / 3600
        total_hours += hours
        estimates.append(f"   {code:7} about {hours:.1f} hours")
    lines += ["", f"4. Estimated time for the full run ({config.FULL_PROMPT_COUNT} prompts x "
              f"{runs_per_prompt} runs = {full_per_model} answers per model)"] + estimates
    lines += [f"   total   about {total_hours:.1f} hours", "", "5. Was a Dockerfile found in each answer?"]
    for method, count in df["extraction"].value_counts().items():
        lines.append(f"   {method:15} {count}")
    report = "\n".join(lines)
    (folder["data"] / "pilot_report.txt").write_text(report + "\n", encoding="utf-8")
    print("\n" + report + f"\n\nSaved to {helpers.rel(folder['data'] / 'pilot_report.txt')}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate Dockerfiles with Qwen via Ollama.")
    parser.add_argument("--pilot", action="store_true", help="small test run into data_pilot/")
    parser.add_argument("--model", action="append", default=[],
                        help="only this model code, e.g. q7b (can be repeated)")
    parser.add_argument("--show-prompts", action="store_true", help="print the prompts and stop")
    parser.add_argument("--status", action="store_true", help="show progress and stop")
    parser.add_argument("--reextract", action="store_true", help="re-cut Dockerfiles from saved answers")
    parser.add_argument("--sample", type=int, metavar="N", help="list N random answers to check by eye")
    parser.add_argument("--allow-model-change", action="store_true", help=argparse.SUPPRESS)
    args = parser.parse_args()

    unknown = [m for m in args.model if m not in config.MODELS.values()]
    if unknown:
        sys.exit(f"Unknown model code {unknown}. Use one of: {', '.join(config.MODELS.values())}")
    folder = helpers.folders(args.pilot)
    prompts = load_prompts()
    if args.show_prompts:
        show_prompts(prompts)
        return
    if args.reextract:
        reextract(folder)
        return
    if args.sample:
        sample(folder, args.sample)
        return
    jobs = build_jobs(prompts, args.pilot, args.model)
    if args.status:
        show_status(jobs, folder)
        return
    check_settings(folder, current_settings(prompts))
    generate(jobs, folder, args.allow_model_change)
    if args.pilot:
        pilot_report(folder)


if __name__ == "__main__":
    main()
