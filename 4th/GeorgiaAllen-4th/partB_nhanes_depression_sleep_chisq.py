# PSYC 3000A - Week 4 assignment, Part B
# Chi-square test of independence on NHANES:
#   HowOftenDoYouFeelDepressed x EverToldDoctorHadTroubleSleeping
# Run in the Student Statistics Lab (SPySS), "12. Chi-square test" editor
import numpy as np
import pandas as pd
import pingouin as pg
from scipy.stats import chi2_contingency

nhanes = pd.read_csv("https://raw.githubusercontent.com/Psyc3000A/Data/refs/heads/main/nhanes.csv")

row, col = 'HowOftenDoYouFeelDepressed', 'EverToldDoctorHadTroubleSleeping'

# Contingency table (rows with missing values on either variable are dropped)
table = pd.crosstab(nhanes[row], nhanes[col])
print(table)

# Row percentages (easier to read)
pct = (pd.crosstab(nhanes[row], nhanes[col], normalize='index') * 100).round(2)
print(pct)

# Chi-square test
chi2, p, dof, expected = chi2_contingency(table)

# Effect size: Cramer's V
n = table.to_numpy().sum()
r, c = table.shape
cramers_v = np.sqrt(chi2 / (n * min(r - 1, c - 1)))
print(f"\nChi2({dof}) = {chi2:.3f}, p = {p:.6g}, Cramer's V = {cramers_v:.3f}, N = {n}")

# Standardized (Pearson) residuals: (O - E) / sqrt(E)
expected_df = pd.DataFrame(expected, index=table.index, columns=table.columns)
residuals = (table - expected_df) / np.sqrt(expected_df)
print(residuals.round(2))

# Cross-check with pingouin
expected2, observed2, result = pg.chi2_independence(data=nhanes, x=row, y=col)
print(result)
