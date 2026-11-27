# Week 4 – Chi-square tests of independence
**Georgia Allen – PSYC 3000A**

All analyses were run in the Student Statistics Lab (SPySS), "12. Chi-square test". Code: `partA_treatment_outcome_chisq.py` and `partB_nhanes_depression_sleep_chisq.py`.

---

## A. Treatment × Outcome (SPySS "Categorical data", N = 120)

**Observed counts (row %)**

| Treatment | Improved | Not improved |
|---|---|---|
| Program | 50 (83.3%) | 10 (16.7%) |
| Usual care | 35 (58.3%) | 25 (41.7%) |

Expected count in every cell = 42.5 (Improved) / 17.5 (Not improved).

**Test output (pingouin, Pearson with Yates continuity correction for 2 × 2):** χ²(1) = 7.906, p = .0049, Cramér's V = 0.257, power = .80
(Without the correction: χ²(1) = 9.08, p = .003, V = 0.275.)

**Standardized residuals**

| Treatment | Improved | Not improved |
|---|---|---|
| Program | 1.07 | −1.67 |
| Usual care | −1.07 | 1.67 |

**APA report**

- **Chi-square:** A chi-square test of independence showed a significant relation between treatment and outcome, χ²(1, N = 120) = 7.91, p = .005, with more participants improving in the program group (83.3%) than in the usual-care group (58.3%).
- **Effect size:** The strength of this association was small to moderate, Cramér's V (φ) = .26.
- **p-value:** The probability of obtaining an association this large if treatment and outcome were unrelated was low (p = .005 < .05), so the null hypothesis of equal proportions was rejected.
- **Residuals:** Standardized residuals showed fewer "not improved" cases than expected in the program group (−1.67) and more than expected in usual care (1.67), with the opposite pattern for "improved" (±1.07); because no residual exceeded |2|, the effect was spread across cells rather than driven by a single cell.

---

## B. NHANES: HowOftenDoYouFeelDepressed × EverToldDoctorHadTroubleSleeping (N = 5,436 complete cases)

Depression frequency coded 0–4 (higher = more frequent); trouble sleeping coded 0 = No, 1 = Yes.

**Observed counts (row % told doctor had trouble sleeping)**

| Feel depressed | No (0) | Yes (1) | % Yes |
|---|---|---|---|
| 0 | 2137 | 436 | 16.95 |
| 1 | 1236 | 490 | 28.39 |
| 2 | 264 | 181 | 40.67 |
| 3 | 199 | 190 | 48.84 |
| 4 | 107 | 196 | 64.69 |

**Test output:** χ²(4) = 482.605, p = 3.87 × 10⁻¹⁰³, Cramér's V = 0.298

**Standardized residuals**

| Feel depressed | No (0) | Yes (1) |
|---|---|---|
| 0 | 6.27 | −10.18 |
| 1 | −0.45 | 0.73 |
| 2 | −3.27 | 5.32 |
| 3 | −4.95 | 8.05 |
| 4 | −7.61 | 12.36 |

**APA report**

- **Chi-square:** A chi-square test of independence showed a significant relation between how often participants felt depressed and whether they had ever told a doctor they had trouble sleeping, χ²(4, N = 5,436) = 482.61, p < .001; the proportion reporting trouble sleeping rose from 17.0% at the lowest depression frequency to 64.7% at the highest.
- **Effect size:** The association was moderate in strength, Cramér's V = .30.
- **p-value:** The likelihood of this association arising if depression and sleep trouble were independent was extremely small (p = 3.87 × 10⁻¹⁰³, reported as p < .001).
- **Residuals:** Standardized residuals showed that people at the highest depression frequencies reported trouble sleeping far more often than expected (level 4 = 12.36, level 3 = 8.05, level 2 = 5.32), whereas those at the lowest frequency reported it far less often than expected (−10.18); all of these exceed |3| and are the strongest contributors to the significant result, while level 1 contributed little (|residual| < 1).

*Residual rule of thumb (PPT-4): |r| < 2 little evidence; |r| > 2 noteworthy; |r| > 3 strong contributor.*
