x = df[['participant', 'age', 'sleep', 'stress']]
result = pd.DataFrame({
    "N": x.count(), "Missing": x.isna().sum(), "Mean": x.mean(),
    "SD": x.std(), "Median": x.median(), "Minimum": x.min(),
    "Maximum": x.max(), "Skewness": x.skew(), "Kurtosis": x.kurt()
})

