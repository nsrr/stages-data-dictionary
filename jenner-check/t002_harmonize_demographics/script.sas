*******************************************************************************;
* Adapted from scripts/prepare-stages-for-nsrr.sas (nsrr/stages-data-dictionary);
* Section: create harmonized datasets. The NSRR demographic harmonization      ;
* derives nsrr_age, nsrr_age_gt89, nsrr_sex, nsrr_race, nsrr_ethnicity,         ;
* nsrr_bmi, nsrr_current_smoker and nsrr_ever_smoker from the survey variables, ;
* followed by the categorical QA PROC FREQ. Input dataset provided by autoexec. ;
*******************************************************************************;
data stages_harmonized;
  set stages_final;
  *create visitcode variable for Spout to use for graph generation;
    visitcode = 1;

*demographics
*age;
*use modified_dem_0110;
  format nsrr_age 8.2;
  nsrr_age = modified_dem_0110;

*age_gt89;
*use modified_dem_0110;
  format nsrr_age_gt89 $10.;
  if modified_dem_0110 gt 89 then nsrr_age_gt89='yes';
  else if modified_dem_0110 le 89 then nsrr_age_gt89='no';

*sex;
*use dem_0500;
  format nsrr_sex $10.;
  if dem_0500 = 'M' then nsrr_sex = 'male';
  else if dem_0500 = 'F' then nsrr_sex = 'female';
  else if dem_0500 = '.' then nsrr_sex = 'not reported';

*race;
*use dem_1000;
    format nsrr_race $100.;
    if dem_1000 = 0 then nsrr_race = 'not reported';
  else if dem_1000 = 1 then nsrr_race = 'white';
    else if dem_1000 = 2 then nsrr_race = 'black or african american';
    else if dem_1000 = 3 then nsrr_race = 'american indian or alaska native';
    else if dem_1000 = 4 then nsrr_race = 'asian';
  else if dem_1000 = 5 then nsrr_race = 'native hawaiian or other pacific islander';
  else if dem_1000 = 6 then nsrr_race = 'other';

*ethnicity;
*use dem_0900;
  format nsrr_ethnicity $100.;
    if dem_0900 = 1 then nsrr_ethnicity = 'hispanic or latino';
    else if dem_0900 = 0 then nsrr_ethnicity = 'not hispanic or latino';
    else if dem_0900 = . then nsrr_ethnicity = 'not reported';

*anthropometry
*bmi;
*use bmi_s1;
  format nsrr_bmi 10.9;
  nsrr_bmi = dem_0800;

*clinical data/vital signs
  *no bp data;
*bp_systolic;
*bp_diastolic;


*lifestyle and behavioral health
*current_smoker;
*use current_cigarette_smoker;
  format nsrr_current_smoker $100.;
  if current_cigarette_smoker = 1 then nsrr_current_smoker = 'yes';
  else if current_cigarette_smoker = 0  then nsrr_current_smoker = 'no';
  else if current_cigarette_smoker = .  then nsrr_current_smoker = 'not reported';
*ever_smoker;
  *use current_cigarette_smoker, former_cigarette_smoker;
  *note- do not need to include scenarios where current =. but former ne . - dervived from the same variable, so have same individuals that did not report;
  format nsrr_ever_smoker $100.;
  if current_cigarette_smoker = 1 and former_cigarette_smoker = 0 then nsrr_ever_smoker = 'yes';
  else if current_cigarette_smoker = 1 and former_cigarette_smoker = 1 then nsrr_ever_smoker = 'yes';
  else if current_cigarette_smoker = 0 and former_cigarette_smoker = 1 then nsrr_ever_smoker = 'yes';
  else if current_cigarette_smoker = 1 and former_cigarette_smoker = 0 then nsrr_ever_smoker = 'yes';
  else if current_cigarette_smoker = 0 and former_cigarette_smoker = 0 then nsrr_ever_smoker = 'no';
  else if current_cigarette_smoker = . and former_cigarette_smoker = . then nsrr_ever_smoker = 'not reported';

  keep
    subject_code
    visitcode
    nsrr_age
    nsrr_age_gt89
    nsrr_sex
    nsrr_race
    nsrr_ethnicity
    nsrr_bmi
    nsrr_current_smoker
    nsrr_ever_smoker
    ;
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

proc print data=stages_harmonized;
run;
