expected, observed, result = pg.chi2_independence(data=df, x='HowOftenDoYouFeelDepressed', y='TroubleSleepingOrSleepingTooMuch')
residuals = (observed - expected) / np.sqrt(expected)
