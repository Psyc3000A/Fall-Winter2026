pip install –qq pandas matplotlib scipy

import pandas as pd, pingouin as pg
nhanes=pd.read_csv("https://raw.githubusercontent.com/Psyc3000A/Data/refs/heads/main/nhanes.csv")
pg.chi2_independence(nhanes, x="HowOftenDoYouFeelDepressed", y="EverToldDoctorHadTroubleSleeping")