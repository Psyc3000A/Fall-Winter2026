## Lab Question 1
The default dataset has 60 participants and 10 variables, with no missing data. Participants averaged about 39 years old, 6.8 hours of sleep, and a stress score of 15. Each person was measured once and belongs to only one group.

The Sleep dataset is much smaller: 20 rows but only 10 people, because each person tried both drugs (a paired design). It measures one outcome, "extra," the change in hours of sleep, which averaged 1.54 hours.

The main differences are size (60 vs. 10 people), design (independent groups vs. the same people measured twice), and what "sleep" means (total hours vs. extra hours gained).

## Lab Question 2
I used the Categorical data set and ran a chi-square test on treatment (Program vs. Usual care) and outcome (Improved vs. Not improved). With all 120 participants, the result was significant, χ²(1) = 7.91, p = .005, Cramér's V = .26. The Program group improved more than the Usual care group.

I had to google what a "case" meant. It means one record in the dataset, here one participant (one row). I deleted participant 1 (Usual care, Not improved) and re-ran the test with 119 participants: χ²(1) = 7.27, p = .007, Cramér's V = .25. The relationship got slightly weaker but was still significant, so removing one case did not change the conclusion.

When I first tried to delete a case using code, the app kept the deletion each time I clicked "Run analysis," so every run removed another participant and the chi-square kept changing. I noticed because the totals in the Observed table didn't add up. I reset the app and deleted the row directly in the data table instead, so exactly one case was removed.

## Lab Question 3
I uploaded the NHANES data set and ran a chi-square test on HowOftenDoYouFeelDepressed and EverToldDoctorHadTroubleSleeping. Only 5,436 of the 8,366 participants answered both questions, so the test used those 5,436. The result was significant, χ²(4) = 482.6, p < .001, Cramér's V = .30. People who felt depressed more often were much more likely to have told a doctor they had trouble sleeping (about 17% of those who never felt depressed vs. about 65% of those who felt depressed most often).

I then deleted the first ten cases (rows) and re-ran the test. Three of those ten had missing answers, so only seven people actually left the analysis (5,429 remained). The result was almost identical: χ²(4) = 482.7, p < .001, Cramér's V = .30.

Compared to Lab Question 2, where deleting one case out of 120 changed χ² from 7.91 to 7.27, deleting ten cases here made almost no difference. In a large sample, a few cases have very little influence on the result.

## Lab Question 4
I ran a linear regression in the NHANES data with age in years at screening predicting standing height in cm. For all ages (n = 8,016), height = 138.95 + 0.48 × age, R² = .28. Age was a significant predictor (p < .001), but the fit was poor. The graph shows why: height rises quickly from age 2 to about 18 and then levels off in adulthood, so a single straight line does not fit the curved pattern.

I then ran the same regression for children under 18 only (n = 2,572): height = 85.32 + 5.51 × age, R² = .90. For children, each extra year of age predicts about 5.5 cm more height, and age explains about 90% of the variation in height. The relationship is strong and close to linear.

The comparison shows that a linear regression only works well when the relationship is actually linear. Mixing children and adults hides the strong age–height relationship in children, because adults stop growing.
