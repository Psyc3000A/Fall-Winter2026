children = df[df["AgeInYearsAtScreening"] < 18]
result = pg.linear_regression(X=children[['AgeInYearsAtScreening']], y=children['StandingHeightCm'], remove_na=True)
sns.regplot(x=df[['AgeInYearsAtScreening']], y=df['StandingHeightCm'])
    