#df = pd.read_csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/hate-crimes/hate_crimes.csv")
x = df[['A', 'extra', 'group', 'ID']]
result = pd.DataFrame({
    "N": x.count(), "Missing": x.isna().sum(), "Mean": x.mean(),
    "SD": x.std(), "Median": x.median(), "Minimum": x.min(),
    "Maximum": x.max(), "Skewness": x.skew(), "Kurtosis": x.kurt()
})