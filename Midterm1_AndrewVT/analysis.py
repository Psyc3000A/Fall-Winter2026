result = pg.linear_regression(X=df[['age']], y=df['participant'], remove_na=True)
sns.regplot(x=df[['age']], y=df['participant'])