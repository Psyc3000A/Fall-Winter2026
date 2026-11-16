expected, observed, result = pg.chi2_independence(data=df, x='EverToldDoctorHadTroubleSleeping', y='HowOftenDoYouFeelDepressed')
residuals = (observed - expected) / np.sqrt(expected)