df = pd.DataFrame({
    "studyTime": [0.67, 1.00, 1.67, 2.00, 2.00, 1.67, 3.33, 4.00],
    "grade": [77, 85, 84, 80, 90, 77, 98, 93],
        "motivation": [77, 95, 154, 80, 210, 77, 198, 93],

})

df["mot_bin"] = (df["motivation"] > df["motivation"].median()).astype(int)
df["motivation"] = df["mot_bin"].map({0: "Low (0)", 1: "High (1)"})

sl.code(smf.ols("grade ~ studyTime * mot_bin", data=df).fit().summary())
sns.lmplot(data=df, x="studyTime", y="grade", hue="motivation")