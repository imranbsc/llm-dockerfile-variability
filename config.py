"""
All settings for the experiment live in this one file.

Change them BEFORE the full run, never in the middle of it. generate.py refuses
to continue an existing data folder if the prompts, the prompt template, the
seeds or the generation options were changed, because the data would no longer
be comparable.
"""

# ---------------------------------------------------------------------------
# Models: Ollama name -> short code used in file names
# ---------------------------------------------------------------------------
MODELS = {
    "qwen2.5-coder:1.5b": "q1.5b",
    "qwen2.5-coder:3b": "q3b",
    "qwen2.5-coder:7b": "q7b",
}

# ---------------------------------------------------------------------------
# Temperatures and how many runs (repetitions) each prompt gets per model
# ---------------------------------------------------------------------------
RUNS_PER_TEMPERATURE = {
    0.0: 10,   # most likely token; the pilot showed it does NOT always repeat
    0.8: 10,   # Ollama's default temperature: answers vary
}

# Run r uses seed SEED_START + r - 1, so runs 1..10 use seeds 1..10.
SEED_START = 1

# ---------------------------------------------------------------------------
# Generation options sent with every request
# ---------------------------------------------------------------------------
NUM_CTX = 4096            # context window in tokens (prompt + answer must fit)
NUM_PREDICT = 1024        # cap on the answer length, in tokens (Section 4.4 of the paper)
KEEP_ALIVE = "30m"        # keep the model loaded between requests
REQUEST_TIMEOUT_S = 900   # give up on a single request after 15 minutes
OLLAMA_HOST = "http://localhost:11434"

# ---------------------------------------------------------------------------
# The sentence wrapped around every app description in prompts.csv.
# {app} is replaced by the text in the "app" column.
# ---------------------------------------------------------------------------
PROMPT_TEMPLATE = (
    "Create a Dockerfile for {app}. "
    "Return the Dockerfile only."
)

# ---------------------------------------------------------------------------
# Pilot run:  python generate.py --pilot
# DONE on 14 October 2026 with the earlier prompt set (prompts_pilot_2026-10-14.csv,
# template "Write a Dockerfile for {app}. Reply with only the Dockerfile in one
# code block.", 2048-token cap). Its exact prompts are saved in
# data_pilot/settings.json. It is not run again.
# ---------------------------------------------------------------------------
PILOT_PROMPTS = ["P01", "P15"]
PILOT_RUNS_PER_TEMPERATURE = {0.0: 3, 0.8: 3}

# Number of prompts and runs of the FULL experiment (used for time estimates).
FULL_PROMPT_COUNT = 30

# ---------------------------------------------------------------------------
# Main smell measure for the tests and Figure 1 (decide BEFORE the final analysis):
#   "hl_total"     all hadolint findings (error, warning, info and style)
#   "hl_warn_err"  only hadolint warnings and errors
# ---------------------------------------------------------------------------
MAIN_SMELL_MEASURE = "hl_total"
