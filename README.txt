DOCKERFILE STUDY - the order of commands
=========================================

Open PowerShell in this folder.
If you use a virtual environment, activate it first:  .\.venv\Scripts\Activate.ps1

CHECK (2 minutes)
    python check_setup.py

PILOT - done on 14 October 2026 (data_pilot\, results_pilot\).
    It used the earlier prompt set, saved as prompts_pilot_2026-10-14.csv.

FULL EXPERIMENT (about 8-9 hours, overnight)
    python generate.py --show-prompts   the 30 prompts exactly as they are sent
    python generate.py                  all 1,800 answers (3 models x 30 prompts x 2 temperatures x 10 runs)
    python generate.py --status         progress at any time (in a second PowerShell window)

AFTER THE RUN (about 20-30 minutes)
    python lint_all.py
    python analyze.py

Stopped by accident (Ctrl+C, crash, laptop asleep)? Run the same command
again: finished answers are kept and the script continues where it stopped.

Before the overnight run: plug in the charger and set Windows to never sleep
while plugged in (Settings > System > Power & battery > Screen and sleep).

Never edit or delete files in data\ by hand: they are your raw data.
Back up the whole folder (zip it to Google Drive) after the run.
