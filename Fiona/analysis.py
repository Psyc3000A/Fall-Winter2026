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

df_under18 = df[df['AgeInYearsAtScreening'] < 18]
result = pg.linear_regression(X=df_under18[['AgeInYearsAtScreening']], y=df_under18['StandingHeightCm'], remove_na=True)
sns.regplot(x=df_under18[['AgeInYearsAtScreening']], y=df_under18['StandingHeightCm'])
