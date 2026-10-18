"""
Replication of Study 1 from Ruigendijk & Koole (2014), Motivation and Emotion, 38(5), 659-672.
Reproduces Table 1 (mean errors), the Orientation x Focus F-test, and Figure 1.

Requires: pandas, numpy, matplotlib, statsmodels  (pip install pandas numpy matplotlib statsmodels)

Code Written with help from Claude AI.
Liam Steadman, October 2026
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
import statsmodels.formula.api as smf

# 1. Import raw data from GitHub
URL = "https://raw.githubusercontent.com/Psyc3000A/Fall-Winter2026/main/ActionControl1.csv"
df = pd.read_csv(URL)

# Column names in the CSV (shortened for readability below)
EXCLUDED = "Subjects that were removed from analysis"
ORIENT = "Median split ACS scores on aod facet"
INCONG = "Number of errors on incongruent trials stroop task"
NEUTRAL = "Number of errors on neutral trials stroop task"

# 2. Prepare data
# Keep the 59 participants analysed by the authors (4 of 63 were excluded)
d = df[df[EXCLUDED] == 0].copy()

# Orientation: the file's "median split" column follows the paper's rule
# (6+ action-oriented answers on the decisiveness scale = action-oriented)
d["orientation"] = d[ORIENT].map({
    "actie": "Action-oriented",
    "toestands": "State-oriented",
})

# Intention focus condition: 1 = weak, 2 = strong
d["focus"] = d["condition"].map({1: "Weak", 2: "Strong"})

# Stop with an error if any label failed to map (instead of silently dropping rows)
assert d["orientation"].notna().all() and d["focus"].notna().all(), "Unmapped label found"

# Stroop interference (errors) = incongruent errors - neutral errors
d["interference"] = d[INCONG] - d[NEUTRAL]

# 3. Table 1: mean errors (SD) by intention focus and orientation
order = [
    ("Strong", "Action-oriented"),
    ("Strong", "State-oriented"),
    ("Weak", "Action-oriented"),
    ("Weak", "State-oriented"),
]


def fmt(group, column):
    return f"{group[column].mean():.2f} ({group[column].std():.2f})"


rows = []
for focus, orientation in order:
    g = d[(d["focus"] == focus) & (d["orientation"] == orientation)]
    rows.append({
        "Focus": focus,
        "Orientation": orientation,
        "N": len(g),
        "Incongruent": fmt(g, INCONG),
        "Neutral": fmt(g, NEUTRAL),
        "Interference": fmt(g, "interference"),
    })

table = pd.DataFrame(rows)
print("\nTable 1: Mean errors (SD)\n")
print(table.to_string(index=False))

# 4. F-test: Orientation x Intention focus interaction on Stroop interference
# (equivalent to the paper's 3-way interaction with trial type; paper reports F(1, 55) = 7.42)
model = smf.ols("interference ~ C(orientation, Sum) * C(focus, Sum)", data=d).fit()
anova = sm.stats.anova_lm(model, typ=3)
row = anova.loc["C(orientation, Sum):C(focus, Sum)"]
df_error = int(anova.loc["Residual", "df"])
eta_sq = row["sum_sq"] / (row["sum_sq"] + anova.loc["Residual", "sum_sq"])

print("\nOrientation x Focus interaction on Stroop interference:")
print(f"F(1, {df_error}) = {row['F']:.2f}, p = {row['PR(>F)']:.3f}, partial eta squared = {eta_sq:.2f}")

# 5. Figure 1: Stroop interference by orientation and intention focus
colors = {"Weak": "#0072B2", "Strong": "#E69F00"}
groups = ["State-oriented", "Action-oriented"]
x = np.arange(len(groups))
width = 0.32

fig, ax = plt.subplots(figsize=(7, 4.4), dpi=200)

for i, focus in enumerate(["Weak", "Strong"]):
    means, errors = [], []

    for orientation in groups:
        g = d[(d["focus"] == focus) & (d["orientation"] == orientation)]
        means.append(g["interference"].mean())
        errors.append(g["interference"].std() / np.sqrt(len(g)))  # standard error

    positions = x + (i - 0.5) * (width + 0.04)

    ax.bar(positions, means, width, color=colors[focus],
           label=f"{focus} intention focus", zorder=2)
    ax.errorbar(positions, means, yerr=errors, fmt="none",
                ecolor="#333333", capsize=3, lw=1, zorder=3)

    for pos, mean, error in zip(positions, means, errors):
        ax.text(pos, mean + error + 0.07, f"{mean:.2f}",
                ha="center", va="bottom", fontsize=9)

ax.set_xticks(x)
ax.set_xticklabels(groups, fontsize=11)
ax.set_ylabel("Stroop interference\n(incongruent - neutral errors)")
ax.set_ylim(0, 3.1)
ax.yaxis.grid(True, color="#dddddd", lw=0.8)
ax.set_axisbelow(True)

for side in ("top", "right"):
    ax.spines[side].set_visible(False)

ax.legend(frameon=False, fontsize=10)
ax.set_title("Study 1: Stroop interference by orientation and intention focus",
             loc="left", fontsize=11)
fig.text(0.01, 0.01, f"Bars = means; error bars = ±1 SE. N = {len(d)}.",
         fontsize=7.5, color="#555555")

fig.tight_layout(rect=(0, 0.03, 1, 1))

# 6. Display figure (not saved)
plt.show()
