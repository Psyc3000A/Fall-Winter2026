x = df[['participant', 'age', 'sleep', 'stress']]
result = pd.DataFrame({
    "N": x.count(), "Missing": x.isna().sum(), "Mean": x.mean(),
    "SD": x.std(), "Median": x.median(), "Minimum": x.min(),
    "Maximum": x.max(), "Skewness": x.skew(), "Kurtosis": x.kurt()
})
= df[['A', 'extra', 'group', 'ID']]
result = x.describe()
result = pg.linear_regression(X=df[['EverBreastfedOrFedBreastmilk']], y=df['StandingHeightCm'], remove_na=True)
sns.regplot(x=df[['EverBreastfedOrFedBreastmilk']], y=df['StandingHeightCm'])
