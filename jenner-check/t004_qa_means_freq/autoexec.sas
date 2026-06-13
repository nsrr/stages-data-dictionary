*******************************************************************************;
* autoexec for t004_qa_means_freq                                             ;
* options obs=100 bounds output. A stand-in stages_harmonized dataset supplies ;
* the harmonized NSRR columns the QA checks read, so the continuous-variable   ;
* PROC MEANS and the categorical PROC FREQ from prepare-stages-for-nsrr.sas    ;
* run on their own. Categorical values follow the harmonized domain labels.    ;
*******************************************************************************;
options obs=100 nofmterr;

data stages_harmonized;
  length subject_code $12 nsrr_age_gt89 $10 nsrr_sex $10 nsrr_race $100
         nsrr_ethnicity $100 nsrr_current_smoker $100 nsrr_ever_smoker $100;
  input subject_code $ visitcode nsrr_age nsrr_bmi nsrr_age_gt89 $ nsrr_sex $
        nsrr_race $ nsrr_ethnicity $ nsrr_current_smoker $ nsrr_ever_smoker $;
  datalines;
STAGES0001 1 34 24.3 no male white not_hispanic no no
STAGES0002 1 58 31.7 no female black hispanic yes yes
STAGES0003 1 91 27.0 yes male asian not_hispanic yes yes
STAGES0004 1 45 22.1 no female not_reported not_reported no yes
STAGES0005 1 67 29.9 no male other not_hispanic no no
;
run;
