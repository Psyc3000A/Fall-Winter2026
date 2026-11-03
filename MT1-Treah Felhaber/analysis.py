x = df[['participant', 'age', 'sleep', 'stress']]
result = pd.DataFrame({
    "N": x.count(), "Missing": x.isna().sum(), "Mean": x.mean(),
    "SD": x.std(), "Median": x.median(), "Minimum": x.min(),
    "Maximum": x.max(), "Skewness": x.skew(), "Kurtosis": x.kurt()
})
x = df[['A', 'extra', 'group', 'ID']]
result = x.Describe()
expected, observed, result = pg.chi2_independence(data=df, x='gender', y='adherence')
result = pg.linear_regression(X=df[['AgeInYearsAtScreening']], y=df['StandingHeightCm'], remove_na=True)
sns.regplot(x=df[['AgeInYearsAtScreening']], y=df['StandingHeightCm'])
