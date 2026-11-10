"""
Checks that everything the experiment needs is installed and working.

    python check_setup.py

Every line starts with [OK] or [!!]. Fix every [!!] line before you continue;
the line below it says how.
"""

from __future__ import annotations

import importlib.metadata as metadata
import platform
import sys

import config
import helpers

problems: list[str] = []


def ok(message: str) -> None:
    print(f"[OK]  {message}")


def bad(message: str, fix: str) -> None:
    print(f"[!!]  {message}\n      -> {fix}")
    problems.append(message)


def main() -> None:
    print(f"Checking the setup on {platform.platform()}\n")

    # 1. Python version
    major, minor = sys.version_info[:2]
    if (3, 12) <= (major, minor) <= (3, 13):
        ok(f"Python {platform.python_version()}")
    else:
        bad(f"Python {platform.python_version()} (the packages need Python 3.12 or 3.13)",
            "install Python 3.13 and recreate the virtual environment (guide, Step 1)")
    if sys.prefix == sys.base_prefix:
        print("[--]  no virtual environment is active (fine if every package below is [OK])")

    # 2. Python packages
    for package in ("ollama", "pandas", "scipy", "matplotlib", "checkov"):
        try:
            ok(f"package {package} {metadata.version(package)}")
        except metadata.PackageNotFoundError:
            bad(f"package {package} is missing", "pip install -r requirements.txt")

    # 3. Checkov actually starts
    try:
        version = helpers.checkov_version()
        if version:
            ok(f"Checkov runs (version {version})")
        else:
            bad("Checkov did not start", "pip install -r requirements.txt")
    except Exception as error:  # noqa: BLE001 - show any problem to the user
        bad(f"Checkov did not start: {error}", "pip install -r requirements.txt")

    # 4. hadolint
    exe = helpers.find_hadolint()
    if exe is None:
        bad("hadolint not found",
            "put hadolint.exe in this folder (guide, Step 3)")
    else:
        try:
            ok(f"hadolint: {helpers.hadolint_version(exe)}  ({exe})")
        except Exception as error:  # noqa: BLE001
            bad(f"hadolint found at {exe} but does not run: {error}",
                "right-click hadolint.exe > Properties > tick Unblock (guide, Step 3)")

    # 5. Ollama
    try:
        ok(f"Ollama answers at {config.OLLAMA_HOST} (version {helpers.ollama_server_version(config.OLLAMA_HOST)})")
        ollama_running = True
    except Exception:  # noqa: BLE001
        bad(f"Ollama does not answer at {config.OLLAMA_HOST}",
            "start Ollama from the Start menu (llama icon near the clock), then run this again")
        ollama_running = False

    # 6. Models
    if ollama_running:
        try:
            import ollama
            installed = {m.model: (m.digest or "")[:12] for m in ollama.Client(host=config.OLLAMA_HOST).list().models}
            for name in config.MODELS:
                if name in installed:
                    ok(f"model {name} (ID {installed[name]})")
                else:
                    bad(f"model {name} is not downloaded", f"ollama pull {name}")
        except Exception as error:  # noqa: BLE001
            bad(f"could not list the models: {error}", "check that Ollama is running")

    print()
    if problems:
        print(f"{len(problems)} problem(s) to fix. Fix the [!!] lines above, then run this again.")
        sys.exit(1)
    print("Everything is ready.")


if __name__ == "__main__":
    main()
