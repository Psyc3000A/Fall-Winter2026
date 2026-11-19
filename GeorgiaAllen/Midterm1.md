## Lab Question 1
The default dataset has 60 participants and 10 variables, with no missing data. Participants averaged about 39 years old, 6.8 hours of sleep, and a stress score of 15. Each person was measured once and belongs to only one group.

The Sleep dataset is much smaller: 20 rows but only 10 people, because each person tried both drugs (a paired design). It measures one outcome, "extra," the change in hours of sleep, which averaged 1.54 hours.

The main differences are size (60 vs. 10 people), design (independent groups vs. the same people measured twice), and what "sleep" means (total hours vs. extra hours gained).

## Lab Question 2
I used the Categorical data set and ran a chi-square test on treatment (Program vs. Usual care) and outcome (Improved vs. Not improved). With all 120 participants, the result was significant, χ²(1) = 7.91, p = .005, Cramér's V = .26. The Program group improved more than the Usual care group.

I had to google what a "case" meant. It means one record in the dataset, here one participant (one row). I deleted participant 1 (Usual care, Not improved) and re-ran the test with 119 participants: χ²(1) = 7.27, p = .007, Cramér's V = .25. The relationship got slightly weaker but was still significant, so removing one case did not change the conclusion.

When I first tried to delete a case using code, the app kept the deletion each time I clicked "Run analysis," so every run removed another participant and the chi-square kept changing. I noticed because the totals in the Observed table didn't add up. I reset the app and deleted the row directly in the data table instead, so exactly one case was removed.
