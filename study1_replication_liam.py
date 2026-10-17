import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 1. Import raw data from GitHub
URL = "https://raw.githubusercontent.com/Psyc3000A/Fall-Winter2026/main/ActionControl1.csv"
df = pd.read_csv(URL)

# 2. Prepare data
d = df[df["Subjects that were removed from analysis"] == 0].copy()

d["orientation"] = d["Median split ACS scores on aod facet"].map({
    "actie": "Action-oriented",
    "toestands": "State-oriented"
})

d["focus"] = d["condition"].map({
    1: "Weak",
    2: "Strong"
})

d["interference"] = (
    d["Number of errors on incongruent trials stroop task"]
    - d["Number of errors on neutral trials stroop task"]
)

# 3. Generate and print summary table
order = [
    ("Strong", "Action-oriented"),
    ("Strong", "State-oriented"),
    ("Weak", "Action-oriented"),
    ("Weak", "State-oriented")
]

rows = []

for focus, orientation in order:
    g = d[
        (d["focus"] == focus) &
        (d["orientation"] == orientation)
    ]

    def fmt(column):
        return f"{g[column].mean():.2f} ({g[column].std():.2f})"

    rows.append({
        "Focus": focus,
        "Orientation": orientation,
        "N": len(g),
        "Incongruent": fmt(
            "Number of errors on incongruent trials stroop task"
        ),
        "Neutral": fmt(
            "Number of errors on neutral trials stroop task"
        ),
        "Interference": fmt("interference")
    })

table = pd.DataFrame(rows)

print("\nTable 1: Mean errors (SD)\n")
print(table.to_string(index=False))

# 4. Generate Figure 1
colors = {"Weak": "#0072B2", "Strong": "#E69F00"}
groups = ["State-oriented", "Action-oriented"]
x = np.arange(len(groups))
width = 0.32

fig, ax = plt.subplots(figsize=(7, 4.4), dpi=200)

for i, focus in enumerate(["Weak", "Strong"]):
    means, errors = [], []

    for orientation in groups:
        g = d[
            (d["focus"] == focus) &
            (d["orientation"] == orientation)
        ]

        means.append(g["interference"].mean())
        errors.append(
            g["interference"].std() / np.sqrt(len(g))
        )

    positions = x + (i - 0.5) * (width + 0.04)

    ax.bar(
        positions,
        means,
        width,
        color=colors[focus],
        label=f"{focus} intention focus",
        zorder=2
    )

    ax.errorbar(
        positions,
        means,
        yerr=errors,
        fmt="none",
        ecolor="#333333",
        capsize=3,
        lw=1,
        zorder=3
    )

    for pos, mean, error in zip(positions, means, errors):
        ax.text(
            pos,
            mean + error + 0.07,
            f"{mean:.2f}",
            ha="center",
            va="bottom",
            fontsize=9
        )

ax.set_xticks(x)
ax.set_xticklabels(groups, fontsize=11)
ax.set_ylabel(
    "Stroop interference\n(incongruent - neutral errors)"
)
ax.set_ylim(0, 3.1)
ax.yaxis.grid(True, color="#dddddd", lw=0.8)
ax.set_axisbelow(True)

for side in ("top", "right"):
    ax.spines[side].set_visible(False)

ax.legend(frameon=False, fontsize=10)
ax.set_title(
    "Study 1: Stroop interference by orientation and intention focus",
    loc="left",
    fontsize=11
)

fig.text(
    0.01,
    0.01,
    f"Bars = means; error bars = ±1 SE. N = {len(d)}.",
    fontsize=7.5,
    color="#555555"
)

fig.tight_layout(rect=(0, 0.03, 1, 1))

# 5. Display figure without saving it
plt.show()
