kids = df [df['AgeInYearsAtScreening']<18]
result = pg.linear_regression(X=kids[['AgeInYearsAtScreening']], y=kids['StandingHeightCm'], remove_na=True)
sns.regplot(x=kids[['AgeInYearsAtScreening']], y=kids['StandingHeightCm'])