# PSYC 3000A - Week 4 assignment, Part A
# Chi-square test of independence: Treatment x Outcome
# Run in the Student Statistics Lab (SPySS):
#   Built-in teaching dataset = "Categorical data", Analysis = "12. Chi-square test"
#   (SPySS provides `df` and `pg` = pingouin)
import numpy as np
import pandas as pd
import pingouin as pg

# df = SPySS "Categorical data" dataset (120 rows x 6 columns)

# Observed counts
table = pd.crosstab(df['treatment'], df['outcome'])
print("Observed counts:")
print(table)

# Chi-square test (pingouin default: Yates continuity correction for 2 x 2 tables)
expected, observed, result = pg.chi2_independence(data=df, x='treatment', y='outcome')
print("\nExpected counts:")
print(expected.round(2))
print("\nChi-square statistics:")
print(result)

# Standardized (Pearson) residuals: (O - E) / sqrt(E)
resid = (observed - expected) / np.sqrt(expected)
print("\nStandardized residuals:")
print(resid.round(2))

n = table.to_numpy().sum()
print("N =", n)

# Same test without the continuity correction (for reference)
_, _, res_nc = pg.chi2_independence(data=df, x='treatment', y='outcome', correction=False)
print("\nWithout Yates correction:")
print(res_nc.iloc[0])
