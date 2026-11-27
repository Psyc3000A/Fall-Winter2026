df = pd.read_csv("https://raw.githubusercontent.com/Psyc3000A/Data/refs/heads/main/nhanes.csv")
expected, observed, result = pg.chi2_independence(data=df, x='HowOftenDoYouFeelDepressed', y='EverToldDoctorHadTroubleSleeping')
residuals = (observed - expected) / np.sqrt(expected)
