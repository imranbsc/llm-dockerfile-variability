"""
Step 7 - turn the lint results into tables, statistical tests and charts.

    python analyze.py           results/       -> results/tables, results/figures, results/report.txt
    python analyze.py --pilot   results_pilot/ -> the same, without tests (too few prompts)

The unit of analysis is the PROMPT: for every prompt, model and temperature the
script first averages over the repeated runs, which gives 30 values per
condition (Section 4.5 of the paper). The tests are:

  * a two-way repeated-measures ANOVA with temperature (2 levels) and model
    size (3 levels) as within-prompt factors, Greenhouse-Geisser correction
    where Mauchly's test shows that sphericity is violated, partial eta squared;
  * the aligned rank transform (ART) ANOVA (Wobbrock et al., 2011) instead,
    when the Shapiro-Wilk test shows that the residuals are not normal;
  * pairwise comparisons of the model sizes with the Holm correction;
  * for H2, a linear trend contrast over model size (1.5b -> 3b -> 7b).

Both the ANOVA and the ART results are printed in report.txt; the decision
rule above says which one goes into the paper.
"""

from __future__ import annotations

import argparse
import itertools
import sys

import numpy as np
import pandas as pd
from scipy import stats

import matplotlib
matplotlib.use("Agg")  # draw straight into files, no window
import matplotlib.pyplot as plt

import config
import helpers

MIN_PROMPTS_FOR_TESTS = 6
PARSE_ERROR = "DL1000"
ALPHA = 0.05
KEYS = ["prompt_id", "model_code", "temperature"]
P_COLUMNS = {"p", "p_holm", "p_uncorrected", "p_GG", "p_spher"}

# Chart style: thin marks, hairline grid, text in ink colours, data in series colours.
INK, INK_2, GRID, AXIS = "#0b0b0b", "#52514e", "#e1e0d9", "#c3c2b7"
SERIES = ["#2a78d6", "#eb6834", "#1baf7a"]  # slot 1 blue, slot 2 orange, slot 3 aqua


# ---------------------------------------------------------------------------
# Loading
# ---------------------------------------------------------------------------
def load(folder: dict):
    path = folder["results"] / "files.csv"
    if not path.exists():
        sys.exit(f"{helpers.rel(path)} not found. Run lint_all.py first.")
    files = pd.read_csv(path)
    hadolint = pd.read_csv(folder["results"] / "hadolint_findings.csv")
    checkov = pd.read_csv(folder["results"] / "checkov_findings.csv")
    runs = pd.read_csv(folder["runs_csv"])
    order = [c for c in config.MODELS.values() if c in set(files["model_code"])]
    files["model_code"] = pd.Categorical(files["model_code"], categories=order, ordered=True)
    files["temperature"] = files["temperature"].astype(float)
    files["hl_warn_err"] = files["hl_warning"] + files["hl_error"]
    files["text"] = [
        helpers.normalize((folder["dockerfiles"] / f"{rid}.Dockerfile").read_text(encoding="utf-8"))
        if has == 1 else None
        for rid, has in zip(files["run_id"], files["has_dockerfile"])
    ]
    return files, hadolint, checkov, runs, order


def fmt(df: pd.DataFrame) -> str:
    df = df.copy()
    for col in df.columns:
        if str(col) in P_COLUMNS and pd.api.types.is_float_dtype(df[col]):
            df[col] = df[col].map(pfmt)
    return df.to_string(float_format=lambda v: f"{v:.3f}")


def pfmt(p) -> str:
    """p-values as they are reported in papers: three decimals, or <0.001."""
    if p is None or (isinstance(p, float) and np.isnan(p)):
        return "n/a"
    return "<0.001" if p < 0.001 else f"{p:.3f}"


# ---------------------------------------------------------------------------
# Descriptive tables
# ---------------------------------------------------------------------------
def overview(files: pd.DataFrame) -> pd.DataFrame:
    g = files.groupby(["model_code", "temperature"], observed=True)
    return pd.DataFrame({
        "answers": g.size(),
        "with_dockerfile": g["has_dockerfile"].sum(),
        "parse_errors": g["parse_ok"].apply(lambda s: int((s == 0).sum())),
        "valid": g.apply(lambda d: int(((d["has_dockerfile"] == 1) & (d["parse_ok"] == 1)).sum()),
                         include_groups=False),
        "cut_off_answers": g["done_reason"].apply(lambda s: int((s == "length").sum())),
        "ignore_pragmas": g["ignore_pragma"].sum(min_count=1).fillna(0).astype(int),
    })


def runtime(runs: pd.DataFrame) -> pd.DataFrame:
    """Speed and duration of the generation, per model (for Data Collection Methods)."""
    ok = runs[runs["status"] == "ok"].copy()
    ok["ts"] = pd.to_datetime(ok["timestamp_utc"], utc=True)
    g = ok.groupby("model_code", sort=False)
    return pd.DataFrame({
        "answers": g.size(),
        "median_s_per_answer": g["total_s"].median(),
        "median_output_tokens": g["output_tokens"].median(),
        "max_output_tokens": g["output_tokens"].max(),
        "median_tokens_per_s": g["tokens_per_s"].median(),
        "hours_generating": g["total_s"].sum() / 3600,
        "first_utc": g["ts"].min().dt.strftime("%Y-%m-%d %H:%M"),
        "last_utc": g["ts"].max().dt.strftime("%Y-%m-%d %H:%M"),
    })


def smells_by_condition(valid: pd.DataFrame) -> pd.DataFrame:
    g = valid.groupby(["model_code", "temperature"], observed=True)
    return pd.DataFrame({
        "dockerfiles": g.size(),
        "hl_mean": g["hl_total"].mean(), "hl_sd": g["hl_total"].std(), "hl_median": g["hl_total"].median(),
        "hl_max": g["hl_total"].max(),
        "pct_smell_free": g["hl_total"].apply(lambda s: 100 * (s == 0).mean()),
        "hl_warn_err_mean": g["hl_warn_err"].mean(),
        "hl_distinct_mean": g["hl_distinct"].mean(),
        "ck_mean": g["ck_failed"].mean(), "ck_sd": g["ck_failed"].std(),
        "n_lines_mean": g["n_lines"].mean(),
    })


def smells_by_level(valid: pd.DataFrame) -> pd.DataFrame:
    total = valid[["hl_error", "hl_warning", "hl_info", "hl_style"]].sum()
    return pd.DataFrame({"findings": total, "pct_of_findings": 100 * total / max(total.sum(), 1),
                         "pct_files_with_level": [100 * (valid[c] > 0).mean() for c in total.index]})


def by_factor(valid: pd.DataFrame, var: pd.DataFrame, column: str) -> pd.DataFrame:
    """Exploratory: smells and similarity by technology stack or application type."""
    smells = valid.groupby(column)["hl_total"].agg(["mean", "std"]).rename(
        columns={"mean": "hl_mean", "std": "hl_sd"})
    smells["pct_smell_free"] = valid.groupby(column)["hl_total"].apply(lambda s: 100 * (s == 0).mean())
    sim = var.groupby([column, "temperature"])["mean_similarity"].mean().unstack()
    sim.columns = [f"similarity_T{t:g}" for t in sim.columns]
    return smells.join(sim)


def rule_frequency(valid: pd.DataFrame, findings: pd.DataFrame, id_col: str, text_col: str,
                   extra_cols: list[str]) -> pd.DataFrame:
    """Share of Dockerfiles in which each rule appears at least once (overall and per condition)."""
    if findings.empty:
        return pd.DataFrame()
    f = findings[findings[id_col] != PARSE_ERROR].merge(
        valid[["run_id", "model_code", "temperature"]], on="run_id")
    once = f.drop_duplicates(["run_id", id_col])
    info = f.groupby(id_col)[[text_col] + extra_cols].first()
    table = pd.DataFrame({"files_with_rule": once.groupby(id_col).size()})
    table["pct_of_dockerfiles"] = 100 * table["files_with_rule"] / len(valid)
    table["occurrences"] = f.groupby(id_col).size()
    sizes = valid.groupby(["model_code", "temperature"], observed=True).size()
    for (code, temp), n in sizes.items():
        part = once[(once["model_code"] == code) & (once["temperature"] == temp)]
        table[f"pct_{code}_T{temp:.1f}"] = 100 * part.groupby(id_col).size() / n
    table = table.join(info).fillna({c: 0 for c in table.columns if c.startswith("pct_")})
    return table.sort_values("files_with_rule", ascending=False)


def variability(files: pd.DataFrame) -> pd.DataFrame:
    """One row per prompt x model x temperature: how different the repeated runs are."""
    rows = []
    with_file = files[files["has_dockerfile"] == 1]
    for (prompt, code, temp), cell in with_file.groupby(KEYS, observed=True):
        texts = list(cell["text"])
        pairs = [helpers.similarity(a, b) for a, b in itertools.combinations(texts, 2)]
        valid = cell[cell["parse_ok"] == 1]
        rule_sets = [set(str(r).split(";")) - {"", "nan"} for r in valid["hl_rules"]]
        all_rules = set().union(*rule_sets) if rule_sets else set()
        unstable = [r for r in all_rules if not all(r in s for s in rule_sets)]
        first = cell.iloc[0]
        rows.append({
            "prompt_id": prompt, "model_code": code, "temperature": temp,
            "stack": first["stack"], "scenario": first["scenario"],
            "runs": len(cell), "distinct_dockerfiles": cell["norm_sha"].nunique(),
            "all_identical": int(cell["norm_sha"].nunique() == 1),
            "mean_similarity": float(np.mean(pairs)) if pairs else np.nan,
            "distinct_base_images": cell["base_images"].fillna("").nunique(),
            "rules_in_cell": len(all_rules),
            "unstable_rules": len(unstable),
            "smell_instability": len(unstable) / len(all_rules) if all_rules else np.nan,
            "smell_count_varies": int(valid["hl_total"].nunique() > 1),
            "smell_free_and_smelly": int((valid["hl_total"] == 0).any() and (valid["hl_total"] > 0).any()),
            "smell_min": valid["hl_total"].min() if len(valid) else np.nan,
            "smell_max": valid["hl_total"].max() if len(valid) else np.nan,
        })
    return pd.DataFrame(rows)


def variability_summary(var: pd.DataFrame) -> pd.DataFrame:
    return var.groupby(["model_code", "temperature"], observed=True).agg(
        cells=("runs", "size"),
        mean_similarity=("mean_similarity", "mean"), sd_similarity=("mean_similarity", "std"),
        min_similarity=("mean_similarity", "min"),
        mean_distinct_dockerfiles=("distinct_dockerfiles", "mean"),
        pct_cells_all_identical=("all_identical", lambda s: 100 * s.mean()),
        mean_distinct_base_images=("distinct_base_images", "mean"),
        pct_cells_base_image_changes=("distinct_base_images", lambda s: 100 * (s > 1).mean()),
        mean_smell_instability=("smell_instability", "mean"),
        pct_cells_smell_count_varies=("smell_count_varies", lambda s: 100 * s.mean()),
        pct_cells_smell_free_and_smelly=("smell_free_and_smelly", lambda s: 100 * s.mean()),
    )


def per_prompt(valid: pd.DataFrame, var: pd.DataFrame, order: list[str]) -> pd.DataFrame:
    """The analysis dataset: per prompt x model x temperature, averaged over runs."""
    means = valid.groupby(KEYS, observed=True)[
        ["hl_total", "hl_warn_err", "hl_distinct", "ck_failed"]].mean().reset_index()
    out = means.merge(var[KEYS + ["mean_similarity", "distinct_dockerfiles", "all_identical",
                                  "smell_instability"]], on=KEYS, how="outer")
    out["model_code"] = pd.Categorical(out["model_code"].astype(str), categories=order, ordered=True)
    return out


def raw_identity_at_t0(runs: pd.DataFrame) -> pd.DataFrame:
    """Were the raw answers at temperature 0 byte-for-byte identical?"""
    ok = runs[(runs["status"] == "ok") & (runs["temperature"].astype(float) == 0.0)]
    rows = []
    for (prompt, code), cell in ok.groupby(["prompt_id", "model_code"]):
        answers = {(helpers.ROOT / f).read_text(encoding="utf-8") for f in cell["raw_file"]}
        rows.append({"prompt_id": prompt, "model_code": code, "runs": len(cell),
                     "distinct_raw_answers": len(answers)})
    return pd.DataFrame(rows)


def describe_conditions(pp: pd.DataFrame, measure: str) -> pd.DataFrame:
    """M, SD and median of the per-prompt values (n = 30 per condition)."""
    g = pp.groupby(["model_code", "temperature"], observed=True)[measure]
    return pd.DataFrame({"n_prompts": g.count(), "M": g.mean(), "SD": g.std(), "Mdn": g.median()})


# ---------------------------------------------------------------------------
# Statistical tests
# ---------------------------------------------------------------------------
def holm(pvalues: list[float]) -> list[float]:
    """Holm-Bonferroni adjustment for several tests."""
    p = np.asarray(pvalues, dtype=float)
    adjusted, running = np.empty_like(p), 0.0
    for rank, index in enumerate(np.argsort(p)):
        running = max(running, (len(p) - rank) * p[index])
        adjusted[index] = min(1.0, running)
    return adjusted.tolist()


def complete_cases(pp: pd.DataFrame, measure: str) -> pd.DataFrame:
    """Keep prompts that have a value in all 6 conditions (needed for repeated measures)."""
    d = pp[KEYS + [measure]].dropna().copy()
    d["model_code"] = d["model_code"].astype(str)
    n_cells = d.groupby("prompt_id").size()
    full = n_cells[n_cells == n_cells.max()].index
    return d[d["prompt_id"].isin(full)]


def residuals(d: pd.DataFrame, measure: str) -> np.ndarray:
    """Residuals of the repeated-measures model: value - condition mean - prompt mean + grand mean."""
    y = d[measure]
    cond = d.groupby(["model_code", "temperature"])[measure].transform("mean")
    subj = d.groupby("prompt_id")[measure].transform("mean")
    return (y - cond - subj + y.mean()).to_numpy()


def shapiro(values: np.ndarray) -> dict:
    values = values[~np.isnan(values)]
    if len(values) < 3 or np.allclose(values, values[0]):
        return {"W": np.nan, "p": np.nan}
    w, p = stats.shapiro(values)
    return {"W": float(w), "p": float(p)}


def rm_anova(d: pd.DataFrame, dv: str) -> pd.DataFrame:
    """Two-way repeated-measures ANOVA (pingouin), with Mauchly and Greenhouse-Geisser."""
    import pingouin as pg
    a = pg.rm_anova(data=d, dv=dv, within=["temperature", "model_code"], subject="prompt_id",
                    detailed=True, effsize="np2")
    a = a.rename(columns={"p_unc": "p_uncorrected", "p_GG_corr": "p_GG"})
    a["Source"] = a["Source"].replace({"temperature": "Temperature", "model_code": "Model size",
                                       "temperature * model_code": "Temperature x Model size"})
    # Greenhouse-Geisser is applied where Mauchly's test is significant (W10/W07 rule).
    a["corrected"] = (a["p_spher"] < ALPHA) & (a["ddof1"] > 1)
    a["p"] = np.where(a["corrected"], a["p_GG"], a["p_uncorrected"])
    a["df1_used"] = np.where(a["corrected"], a["ddof1"] * a["eps"], a["ddof1"])
    a["df2_used"] = np.where(a["corrected"], a["ddof2"] * a["eps"], a["ddof2"])
    cols = ["Source", "ddof1", "ddof2", "F", "p_uncorrected", "W_spher", "p_spher", "eps",
            "corrected", "df1_used", "df2_used", "p", "np2"]
    return a[cols].set_index("Source")


def art_align(d: pd.DataFrame, dv: str) -> dict[str, pd.Series]:
    """
    Aligned responses for each effect (Wobbrock et al., 2011): the residual
    (value - cell mean) plus the estimated effect of interest only.
    """
    y = d[dv]
    grand = y.mean()
    cell = d.groupby(["temperature", "model_code"])[dv].transform("mean")
    a_mean = d.groupby("temperature")[dv].transform("mean")
    b_mean = d.groupby("model_code")[dv].transform("mean")
    resid = y - cell
    return {
        "Temperature": resid + (a_mean - grand),
        "Model size": resid + (b_mean - grand),
        "Temperature x Model size": resid + (cell - a_mean - b_mean + grand),
    }


def art_anova(d: pd.DataFrame, dv: str) -> tuple[pd.DataFrame, float]:
    """
    ART ANOVA: align, rank (mid-ranks for ties), run the full factorial
    repeated-measures ANOVA on the ranks, keep only the effect the data were
    aligned for. Also returns the largest F of the other effects on the
    aligned (unranked) data, which should be about 0 if the alignment is right.
    """
    rows, check = [], 0.0
    for effect, aligned in art_align(d, dv).items():
        data = d.assign(aligned=aligned, ranked=stats.rankdata(aligned))
        result = rm_anova(data, "ranked")
        rows.append(result.loc[[effect]])
        on_aligned = rm_anova(data, "aligned")
        others = on_aligned.drop(index=effect)["F"].abs()
        check = max(check, float(others.max()))
    return pd.concat(rows), check


def paired_tests(wide: pd.DataFrame, parametric: bool) -> pd.DataFrame:
    """All pairs of columns: paired t-tests (d_z) or Wilcoxon signed-rank (r_rb); Holm-corrected."""
    rows = []
    wide = wide.dropna()
    for a, b in itertools.combinations(wide.columns, 2):
        x, y = wide[a].to_numpy(float), wide[b].to_numpy(float)
        diff = x - y
        row = {"pair": f"{a} vs {b}", "n": len(diff), "M_diff": diff.mean(), "Mdn_diff": np.median(diff)}
        if parametric:
            sd = diff.std(ddof=1)
            if sd == 0:
                row.update(t=np.nan, p=1.0, d_z=0.0)
            else:
                t, p = stats.ttest_rel(x, y)
                row.update(t=float(t), p=float(p), d_z=float(diff.mean() / sd))
        else:
            nonzero = diff[diff != 0]
            if len(nonzero) == 0:
                row.update(W=np.nan, p=1.0, r_rb=0.0)
            else:
                res = stats.wilcoxon(x, y, zero_method="wilcox", alternative="two-sided")
                ranks = stats.rankdata(np.abs(nonzero))
                plus, minus = ranks[nonzero > 0].sum(), ranks[nonzero < 0].sum()
                row.update(W=float(res.statistic), p=float(res.pvalue),
                           r_rb=float((plus - minus) / (plus + minus)))
        rows.append(row)
    table = pd.DataFrame(rows).set_index("pair")
    table["p_holm"] = holm(table["p"].tolist())
    return table


def trend_contrast(d: pd.DataFrame, dv: str, order: list[str], parametric: bool) -> dict:
    """Linear trend over model size (weights -1, 0, +1), averaged over temperatures."""
    wide = d.groupby(["prompt_id", "model_code"])[dv].mean().unstack()[order]
    weights = np.linspace(-1, 1, len(order))
    score = (wide * weights).sum(axis=1).to_numpy(float)
    out = {"n": len(score), "M_contrast": score.mean(), "SD_contrast": score.std(ddof=1)}
    if parametric:
        if out["SD_contrast"] == 0:
            return {**out, "t": np.nan, "p": 1.0, "d_z": 0.0}
        t, p = stats.ttest_1samp(score, 0.0)
        return {**out, "t": float(t), "df": len(score) - 1, "p": float(p),
                "d_z": float(score.mean() / out["SD_contrast"])}
    nonzero = score[score != 0]
    if len(nonzero) == 0:
        return {**out, "W": np.nan, "p": 1.0, "r_rb": 0.0}
    res = stats.wilcoxon(score, zero_method="wilcox", alternative="two-sided")
    ranks = stats.rankdata(np.abs(nonzero))
    plus, minus = ranks[nonzero > 0].sum(), ranks[nonzero < 0].sum()
    return {**out, "W": float(res.statistic), "p": float(res.pvalue),
            "r_rb": float((plus - minus) / (plus + minus))}


def test_measure(pp: pd.DataFrame, dv: str, label: str, order: list[str]) -> tuple[list[str], dict]:
    """Assumption check, ANOVA and ART, post hoc tests and the trend contrast for one measure."""
    d = complete_cases(pp, dv)
    n = d["prompt_id"].nunique()
    sw = shapiro(residuals(d, dv))
    parametric = not (sw["p"] < ALPHA) if not np.isnan(sw["p"]) else False
    chosen = "repeated-measures ANOVA" if parametric else "ART ANOVA (aligned rank transform)"
    lines = [f"--- {label}  (measure: {dv}; {n} prompts with all 6 conditions)", "",
             f"   Normality of the residuals (Shapiro-Wilk, {len(d)} residuals): "
             f"W={sw['W']:.3f}, p={pfmt(sw['p'])}  ->  test used in the paper: {chosen}", ""]
    out = {"dv": dv, "n_prompts": n, "shapiro": sw, "parametric": parametric}
    try:
        anova = rm_anova(d, dv)
        lines += ["   Two-way repeated-measures ANOVA" + ("  <- REPORT THIS" if parametric else "  (robustness check)"),
                  fmt(anova), ""]
        out["anova"] = anova
    except Exception as error:  # noqa: BLE001 - e.g. no variance at all
        lines += [f"   Two-way repeated-measures ANOVA could not be computed: {error}", ""]
    try:
        art, check = art_anova(d, dv)
        lines += ["   ART ANOVA on aligned ranks" + ("  <- REPORT THIS" if not parametric else "  (robustness check)"),
                  fmt(art),
                  f"   Alignment check: largest F of the non-target effects on aligned data = {check:.2e} "
                  "(should be about 0)", ""]
        out["art"] = art
    except Exception as error:  # noqa: BLE001
        lines += [f"   ART ANOVA could not be computed: {error}", ""]

    wide_size = d.groupby(["prompt_id", "model_code"])[dv].mean().unstack()[order]
    post = paired_tests(wide_size, parametric)
    lines += ["   Model sizes compared pairwise (averaged over temperature; "
              + ("paired t-tests" if parametric else "Wilcoxon signed-rank tests") + ", Holm-corrected)",
              fmt(post), ""]
    out["posthoc_size"] = post

    temps = sorted(d["temperature"].unique())
    simple = []
    for code in order:
        w = d[d["model_code"] == code].pivot(index="prompt_id", columns="temperature", values=dv)
        r = paired_tests(w[temps], parametric).reset_index()
        r["pair"] = f"{code}: T{temps[0]:g} vs T{temps[1]:g}"
        simple.append(r)
    simple = pd.concat(simple).set_index("pair")
    simple["p_holm"] = holm(simple["p"].tolist())
    lines += ["   Temperature within each model (simple effects, Holm-corrected over the 3 models)",
              fmt(simple), ""]
    out["simple_temperature"] = simple

    trend = trend_contrast(d, dv, order, parametric)
    lines += ["   Linear trend over model size (weights -1, 0, +1; negative = fewer with larger models): "
              + ", ".join(f"{k}={pfmt(v) if k == 'p' else (f'{v:.3f}' if isinstance(v, float) else v)}"
                          for k, v in trend.items()), ""]
    out["trend"] = trend
    return lines, out


def run_tests(pp: pd.DataFrame, order: list[str]) -> tuple[list[str], dict]:
    lines, results = [], {}
    plan = [
        ("mean_similarity", "H1 and RQ3: run-to-run similarity (higher = less variable)"),
        (config.MAIN_SMELL_MEASURE, "H2 and RQ3: smells per Dockerfile (hadolint)"),
        ("hl_warn_err", "Sensitivity check: hadolint warnings and errors only"),
    ]
    for dv, label in plan:
        if dv == "hl_warn_err" and config.MAIN_SMELL_MEASURE == "hl_warn_err":
            continue
        part, res = test_measure(pp, dv, label, order)
        lines += part
        results[dv] = res
    lines += ["How to read this: F tests whether the factor changes the measure; p is the probability",
              "of an effect at least this large if there were no real effect (reject H0 if p <= .05).",
              "np2 (partial eta squared) is the effect size: about .01 small, .06 medium, .14 large.",
              "eps is the Greenhouse-Geisser epsilon; 'corrected' says whether it was applied.",
              "p_holm is p corrected for running several tests. d_z and r_rb are effect sizes",
              "of the pairwise comparisons."]
    return lines, results


# ---------------------------------------------------------------------------
# Charts
# ---------------------------------------------------------------------------
def style(ax, ylabel: str) -> None:
    ax.set_ylabel(ylabel, color=INK)
    ax.grid(axis="y", color=GRID, linewidth=0.8)
    ax.set_axisbelow(True)
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(AXIS)
    ax.tick_params(colors=INK_2)


def save(fig, path) -> None:
    fig.savefig(path, dpi=300, bbox_inches="tight", facecolor="white")
    plt.close(fig)


def config_name(code: str) -> str:
    for name, c in config.MODELS.items():
        if c == code:
            return name.replace("qwen2.5-coder:", "Qwen2.5-Coder ").replace("b", "B")
    return code


def chart_bars(pp: pd.DataFrame, order: list[str], measure: str, ylabel: str, title: str, path,
               ylim=None) -> None:
    """Mean of the prompt means per model and temperature, with 95% confidence intervals."""
    temps = sorted(pp["temperature"].dropna().unique())
    fig, ax = plt.subplots(figsize=(6.4, 3.6))
    width = 0.32
    x = np.arange(len(order))
    for i, temp in enumerate(temps):
        means, errors = [], []
        for code in order:
            values = pp[(pp["model_code"] == code) & (pp["temperature"] == temp)][measure].dropna()
            means.append(values.mean())
            n = len(values)
            errors.append(stats.t.ppf(0.975, n - 1) * values.std() / np.sqrt(n) if n > 1 else 0)
        offset = (i - (len(temps) - 1) / 2) * width
        ax.bar(x + offset, means, width * 0.85, yerr=errors, color=SERIES[i % 3],
               error_kw={"ecolor": INK_2, "elinewidth": 1, "capsize": 3}, label=f"Temperature {temp:g}")
        for xi, m, e in zip(x + offset, means, errors):
            ax.text(xi, m + e + 0.01 * (ylim[1] if ylim else max(means) or 1), f"{m:.2f}",
                    ha="center", va="bottom", fontsize=8, color=INK)
    ax.set_xticks(x, [config_name(c) for c in order])
    if ylim:
        ax.set_ylim(*ylim)
    style(ax, ylabel)
    ax.legend(frameon=False, labelcolor=INK, loc="upper right")
    ax.set_title(title, fontsize=10, color=INK, loc="left")
    save(fig, path)


def chart_similarity(var: pd.DataFrame, order: list[str], path) -> None:
    """Box plots of per-prompt similarity, both temperatures side by side, one dot per prompt."""
    temps = sorted(var["temperature"].unique())
    fig, ax = plt.subplots(figsize=(6.4, 3.6))
    width = 0.32
    rng = np.random.default_rng(1)
    for i, temp in enumerate(temps):
        offset = (i - (len(temps) - 1) / 2) * width
        pos = np.arange(len(order)) + 1 + offset
        data = [var[(var["model_code"] == c) & (var["temperature"] == temp)]["mean_similarity"].dropna().values
                for c in order]
        ax.boxplot(data, positions=pos, widths=width * 0.75, showfliers=False,
                   medianprops={"color": INK, "linewidth": 1.5},
                   boxprops={"color": AXIS}, whiskerprops={"color": AXIS}, capprops={"color": AXIS})
        for p, values in zip(pos, data):
            ax.scatter(p + rng.uniform(-0.07, 0.07, len(values)), values, s=12, color=SERIES[i % 3],
                       alpha=0.8, edgecolors="white", linewidths=0.5, zorder=3,
                       label=f"Temperature {temp:g}" if p == pos[0] else None)
    ax.set_xticks(range(1, len(order) + 1), [config_name(c) for c in order])
    ax.set_ylim(0, 1.04)
    style(ax, "Mean pairwise similarity of the 10 runs")
    ax.legend(frameon=False, labelcolor=INK, loc="lower right")
    ax.set_title("Run-to-run similarity per prompt (1 = identical; one dot per prompt)",
                 fontsize=10, color=INK, loc="left")
    save(fig, path)


def chart_rules(table: pd.DataFrame, label_col: str, title: str, path, top: int = 12) -> None:
    if table.empty:
        return
    t = table.head(top).iloc[::-1]
    labels = [f"{i}  {str(m)[:48]}{'...' if len(str(m)) > 48 else ''}" for i, m in zip(t.index, t[label_col])]
    fig, ax = plt.subplots(figsize=(7.2, 0.32 * len(t) + 0.9))
    ax.barh(labels, t["pct_of_dockerfiles"], height=0.6, color=SERIES[0])
    for y, v in enumerate(t["pct_of_dockerfiles"]):
        ax.text(v + 0.8, y, f"{v:.0f}%", va="center", fontsize=8, color=INK)
    ax.set_xlim(0, max(100, t["pct_of_dockerfiles"].max() + 8))
    ax.grid(axis="x", color=GRID, linewidth=0.8)
    ax.set_axisbelow(True)
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(AXIS)
    ax.tick_params(colors=INK_2, labelsize=8)
    ax.set_xlabel("% of Dockerfiles with this finding", color=INK)
    ax.set_title(title, fontsize=10, color=INK, loc="left")
    save(fig, path)


# ---------------------------------------------------------------------------
def main() -> None:
    parser = argparse.ArgumentParser(description="Tables, tests and charts.")
    parser.add_argument("--pilot", action="store_true", help="analyse the pilot results")
    args = parser.parse_args()
    folder = helpers.folders(args.pilot)
    files, hadolint, checkov, runs, order = load(folder)
    for key in ("tables", "figures"):
        folder[key].mkdir(parents=True, exist_ok=True)
    valid = files[(files["has_dockerfile"] == 1) & (files["parse_ok"] == 1)].copy()

    over = overview(files)
    speed = runtime(runs)
    smells = smells_by_condition(valid)
    levels = smells_by_level(valid)
    hl_rules = rule_frequency(valid, hadolint, "code", "message", ["level"])
    ck_rules = rule_frequency(valid, checkov, "check_id", "check_name", [])
    var = variability(files)
    var["model_code"] = pd.Categorical(var["model_code"].astype(str), categories=order, ordered=True)
    var_summary = variability_summary(var)
    pp = per_prompt(valid, var, order)
    t0 = raw_identity_at_t0(runs)
    stack_table = by_factor(valid, var, "stack")
    type_table = by_factor(valid, var, "scenario")
    desc_sim = describe_conditions(pp, "mean_similarity")
    desc_smell = describe_conditions(pp, config.MAIN_SMELL_MEASURE)

    tables = folder["tables"]
    over.to_csv(tables / "1_overview.csv")
    smells.to_csv(tables / "2_smells_by_model_temperature.csv")
    hl_rules.to_csv(tables / "3_hadolint_rule_frequency.csv")
    ck_rules.to_csv(tables / "4_checkov_check_frequency.csv")
    var_summary.to_csv(tables / "5_variability_by_model_temperature.csv")
    var.to_csv(tables / "6_variability_per_prompt_cell.csv", index=False)
    pp.to_csv(tables / "7_per_prompt_dataset.csv", index=False)
    speed.to_csv(tables / "8_runtime_by_model.csv")
    stack_table.to_csv(tables / "9_by_stack.csv")
    type_table.to_csv(tables / "10_by_application_type.csv")
    levels.to_csv(tables / "11_hadolint_levels.csv")
    pd.concat({"similarity": desc_sim, "smells": desc_smell}).to_csv(tables / "12_per_prompt_descriptives.csv")
    if not t0.empty:
        t0.to_csv(tables / "13_temperature0_raw_identity.csv", index=False)

    figures = folder["figures"]
    chart_similarity(var, order, figures / "fig1_similarity_by_model_temperature.png")
    chart_bars(pp, order, config.MAIN_SMELL_MEASURE,
               "Mean hadolint smells per Dockerfile" if config.MAIN_SMELL_MEASURE == "hl_total"
               else "Mean hadolint warnings + errors per Dockerfile",
               "Smells per Dockerfile by model and temperature (mean of prompt means, 95% CI)",
               figures / "fig2_smells_by_model_temperature.png")
    chart_rules(hl_rules, "message", "Most frequent hadolint findings",
                figures / "fig3_top_hadolint_rules.png")
    chart_rules(ck_rules, "check_name", "Most frequent failed Checkov checks",
                figures / "fig4_top_checkov_checks.png")

    n_prompts = pp["prompt_id"].nunique()
    report = ["ANALYSIS REPORT", "=" * 70, "",
              f"Answers: {len(files)}. Valid Dockerfiles: {len(valid)} "
              "(answers without a Dockerfile and files hadolint could not parse are excluded).", "",
              "1. Overview", fmt(over), "",
              "2. Generation time and speed per model (from runs.csv)", fmt(speed), "",
              "3. Smells per Dockerfile, file level (hl = hadolint, ck = Checkov)", fmt(smells), "",
              "4. hadolint findings by severity level", fmt(levels), "",
              "5. Most frequent hadolint findings (% of valid Dockerfiles)",
              fmt(hl_rules.head(20)[["level", "files_with_rule", "pct_of_dockerfiles", "occurrences", "message"]])
              if not hl_rules.empty else "   none", "",
              "6. Most frequent failed Checkov checks (% of valid Dockerfiles)",
              fmt(ck_rules.head(15)[["files_with_rule", "pct_of_dockerfiles", "check_name"]])
              if not ck_rules.empty else "   none", "",
              "7. Run-to-run variability (one cell = one prompt x model x temperature)", fmt(var_summary), ""]
    if not t0.empty:
        same = int((t0["distinct_raw_answers"] == 1).sum())
        by_model = t0.assign(same=t0["distinct_raw_answers"] == 1).groupby("model_code")["same"].agg(["sum", "size"])
        report += [f"8. Temperature 0: {same} of {len(t0)} prompt x model cells gave byte-identical raw answers "
                   "in every run.", fmt(by_model.rename(columns={"sum": "identical_cells", "size": "cells"})), ""]
    report += ["9. Per-prompt values used in the tests (M, SD, Mdn over prompts)",
               "   similarity:", fmt(desc_sim), f"   {config.MAIN_SMELL_MEASURE}:", fmt(desc_smell), "",
               "10. Exploratory: by technology stack", fmt(stack_table), "",
               "11. Exploratory: by application type", fmt(type_table), ""]
    if n_prompts >= MIN_PROMPTS_FOR_TESTS:
        test_lines, _ = run_tests(pp, order)
        report += ["12. Statistical tests", ""] + test_lines
    else:
        report += [f"12. Statistical tests skipped: only {n_prompts} prompts (need at least "
                   f"{MIN_PROMPTS_FOR_TESTS}). This is expected for the pilot."]
    text = "\n".join(report)
    (folder["results"] / "report.txt").write_text(text + "\n", encoding="utf-8")
    print(text)
    print(f"\nSaved: {helpers.rel(folder['results'] / 'report.txt')}, tables in "
          f"{helpers.rel(tables)}, charts in {helpers.rel(figures)}")


if __name__ == "__main__":
    main()
