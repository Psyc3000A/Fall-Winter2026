x = df[['participant', 'age', 'sleep', 'stress']]
result = pd.DataFrame({
    "N": x.count(), "Missing": x.isna().sum(), "Mean": x.mean(),
    "SD": x.std(), "Median": x.median(), "Minimum": x.min(),
    "Maximum": x.max(), "Skewness": x.skew(), "Kurtosis": x.kurt()
})
x = df[['A', 'extra', 'group', 'ID']]
result = x.describe()

result = pg.linear_regression(X=df[['AgeInYearsAtScreening']], y=df['StandingHeightCm'], remove_na=True)
sns.regplot(x=df[['AgeInYearsAtScreening']], y=df['StandingHeightCm'])

children = df[df]['AgeInYearsAtScreening'] < 18]
result = pg.linear_regression(X=df[['AgeInYearsAtScreening'] < 18], y=df['StandingHeightCm'], remove_na=True)
sns.regplot(x=df[['AgeInYearsAtScreening'] < 18], y=df['StandingHeightCm'])
