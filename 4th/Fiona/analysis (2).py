expected, observed, result = pg.chi2_independence(data=df, x='group', y='outcome')
residuals = (observed - expected) / np.sqrt(expected)
print(residuals)