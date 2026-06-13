*******************************************************************************;
* Adapted from scripts/prepare-stages-for-nsrr.sas (nsrr/stages-data-dictionary);
* Section: checking harmonized datasets. PROC MEANS scans the continuous        ;
* harmonized variables (nsrr_age, nsrr_bmi) for extreme values, and PROC FREQ   ;
* tabulates the categorical harmonized variables. Input dataset provided by the ;
* bundle autoexec.                                                              ;
*******************************************************************************;

/* Checking for extreme values for continuous variables */

proc means data=stages_harmonized;
VAR   nsrr_age
    nsrr_bmi;
run;

/* Checking categorical variables */


proc freq data=stages_harmonized;
table   nsrr_age_gt89
    nsrr_sex
    nsrr_race
    nsrr_ethnicity
    nsrr_current_smoker
    nsrr_ever_smoker;
run;
