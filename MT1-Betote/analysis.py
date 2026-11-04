x = df[['participant', 'age', 'sleep', 'stress']]
result = pd.DataFrame({
    "N": x.count(), "Missing": x.isna().sum(), "Mean": x.mean(),
    "SD": x.std(), "Median": x.median(), "Minimum": x.min(),
    "Maximum": x.max(), "Skewness": x.skew(), "Kurtosis": x.kurt()
})
x = df[['A', 'extra', 'group', 'ID']]
result = x.describe()
#labquestion 3 below
result = pg.linear_regression(X=df[['AgeInYearsAtScreening']], y=df['StandingHeightCm'], remove_na=True)
sns.regplot(x=df[['AgeInYearsAtScreening']], y=df['StandingHeightCm'])
#labquestion 4 below
#the software accompanying labquestion4 is not functioning as properly. I've attempted to type the code myself
result = pg.linear_regression([X =df[["AgeInYearsAtScreening" < 18], y=df["StandingHeightCm"], remove_na=True)
children_sns.regplot(x=df["AgeInYearsAtScreening"], y=df["StandingHeightCm"].hist(bins=200, legend =True)
