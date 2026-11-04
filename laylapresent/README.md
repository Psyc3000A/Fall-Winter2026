# Data from: MEG oscillation-based functional connectivity identifies clinically relevant depression phenotypes

Minimal datasets that can be used to reproduce main findings of this study. Data were collected from 263 patients with major depressive disorder.

## AC_NS_age_gender_regressed.npy contents

The node strength of amplitude correlations computed with the orthogonalized correlation coefficient method, and the age and gender effects were regressed out. The data format is a numpy array with a dimension of [263 subjects * 32 frequencies * 200 parcels]. The frequencies are at 2.15, 2.49, 2.88, 3.31, 3.73, 4.15, 4.75, 5.35, 5.93, 6.62, 7.39, 8.14, 9.02, 9.83, 10.92, 11.89, 13.11, 14.78, 16.3 , 17.8 , 19.7 , 21.6 , 23.73, 26.55, 28.7 , 31.8 , 34.5 , 37.9 , 42.5 , 46.9 , 52.1 , 59.3 in Hz.

## PS_NS_age_gender_regressed.npy contents

The node strength of phase synchrony computed with the weighted phase lag index method, and the age and gender effects were regressed out. The data format is a numpy array with a dimension of [263 subjects * 32 frequencies * 200 parcels]. The frequencies are at 2.15, 2.49, 2.88, 3.31, 3.73, 4.15, 4.75, 5.35, 5.93, 6.62, 7.39, 8.14, 9.02, 9.83, 10.92, 11.89, 13.11, 14.78, 16.3 , 17.8 , 19.7 , 21.6 , 23.73, 26.55, 28.7 , 31.8 , 34.5 , 37.9 , 42.5 , 46.9 , 52.1 , 59.3 in Hz.

## df_symptoms_zscored_PVSS_WHO_inverted.csv contents

The symptom scores collected with 10 self-report questionnaires, including Patient Health Questionnaire (PHQ-9), Quick Inventory of Depressive Symptomatology 16-item (self-report) (QIDS), Generalized Anxiety Disorder 7-item (GAD), The Ruminative Responses Scale Short-version (RRS), Sheehan Disability Scale (SDS), Brief Experiential Avoidance Questionnaire (BEAQ), PTSD Checklist for DSM-5 (PCL), Alcohol, Smoking, and Substance Involvement Screening Test Lite (ASSIST), Positive Valence Systems Scale (PVSS), and WHO-5 Well-Being Index (WHO). The symptom scores were z-scored across the cohort, and PVSS and WHO were inverted by multiplying with -1. All variables are unitless.

## Human subjects data

Data were de-identified, and participants gave their consent to publish the data. The shared dataset doesn't contain direct identifiers that could reasonably identify individual participants.
