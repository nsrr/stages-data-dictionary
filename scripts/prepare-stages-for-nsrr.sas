*******************************************************************************;
* Program           : prepare-stages-for-nsrr.sas
* Project           : National Sleep Research Resource (sleepdata.org)
* Author            : Michael Rueschman (mnr)
* Date Created      : 20200917
* Purpose           : Prepare STAGES data for posting on NSRR.
*******************************************************************************;

*******************************************************************************;
* establish options and libnames ;
*******************************************************************************;
  options nofmterr;
  data _null_;
    call symput("sasfiledate",put(year("&sysdate"d),4.)||put(month("&sysdate"d),z2.)||put(day("&sysdate"d),z2.));
  run;

  *project source datasets;
  libname stagess "\\rfawin\BWH-SLEEPEPI-NSRR-STAGING\20200722-stages\nsrr-prep\_source";

  *output location for nsrr sas datasets;
  libname stagesd "\\rfawin\BWH-SLEEPEPI-NSRR-STAGING\20200722-stages\nsrr-prep\_datasets";
  libname stagesa "\\rfawin\BWH-SLEEPEPI-NSRR-STAGING\20200722-stages\nsrr-prep\_archive";

  *nsrr id location;
  libname stagesi "\\rfawin\BWH-SLEEPEPI-NSRR-STAGING\20200722-stages\nsrr-prep\_ids";

  *set data dictionary version;
  %let version = 0.2.0.pre;

  *set nsrr csv release path;
  %let releasepath = \\rfawin\BWH-SLEEPEPI-NSRR-STAGING\20200722-stages\nsrr-prep\_releases;

*******************************************************************************;
* import asq datasets ;
*******************************************************************************;
  proc import datafile="\\rfawin\BWH-SLEEPEPI-NSRR-STAGING\20200722-stages\nsrr-prep\_source\asq\STAGES ASQ DEM to SLPY 20200513 Final deidentified.xlsx"
    out=asq_dem_in 
    dbms=xlsx
    replace;
  run;

  proc sort data=asq_dem_in nodupkey;
    by subject_code survey_id;
  run;

  proc contents data=asq_dem_in;
  run;


  
proc freq data=asq_dem_in;
table   soclhx_1100;
run;
  proc import datafile="\\rfawin\BWH-SLEEPEPI-NSRR-STAGING\20200722-stages\nsrr-prep\_source\asq\STAGES ASQ ISI to DIET 20200513 Final deidentified.xlsx"
    out=asq_isi_in 
    dbms=xlsx
    replace;
  run;

  proc sort data=asq_isi_in nodupkey;
    by subject_code survey_id;
  run;

  data asq_merge;
    merge
      asq_dem_in
      asq_isi_in
      ;
    by subject_code survey_id;

    *recode false/true character values into 0/1 numeric values;
    if sched_1401 = 'false' then sched_1401_r = 0;
    else if sched_1401 = 'true' then sched_1401_r = 1;

    if sched_1701 = 'false' then sched_1701_r = 0;
    else if sched_1701 = 'true' then sched_1701_r = 1;

    if sched_1801 = 'false' then sched_1801_r = 0;
    else if sched_1801 = 'true' then sched_1801_r = 1;

    if soclhx_0101 = 'false' then soclhx_0101_r = 0;
    else if soclhx_0101 = 'false' then soclhx_0101_r = 1;

    *recode character month values;
    narc_1710_r = input(narc_1710,8.);
	*creating binary smoking variables from soclhx_1100;
	
	format never_cigarette_smoker 8.2;
	if index(soclhx_1100, '0') then never_cigarette_smoker = 1;
	else if soclhx_1100 ne '' then never_cigarette_smoker= 0;

	format former_cigarette_smoker 8.2;
	if index(soclhx_1100, '1') then former_cigarette_smoker = 1;
	else if soclhx_1100 ne '' then former_cigarette_smoker = 0;
	
	format former_smokeless_user 8.2;
	if index(soclhx_1100, '2') then former_smokeless_user = 1;
	else if soclhx_1100 ne '' then former_smokeless_user = 0;
	
	format current_cigarette_smoker 8.2;
	if index(soclhx_1100, '3') then current_cigarette_smoker = 1;
	else if soclhx_1100 ne '' then current_cigarette_smoker = 0;

	format current_smokeless_user 8.2;
	if index(soclhx_1100, '4') then current_smokeless_user = 1;
	else if soclhx_1100 ne '' then current_smokeless_user = 0;

    *remove variables systematically;
    drop
      last_module /* administrative variable */
      next_module /* administrative variable */
      survey_id /* administrative variable */
      map_1125 /* empty variable */
      modified_bthbts_end /* extraneous survey datetime */
      modified_bthbts_start /* extraneous survey datetime */
      modified_cir_end /* extraneous survey datetime */
      modified_cir_start /* extraneous survey datetime */
      modified_dem_end /* extraneous survey datetime */
      modified_dem_start /* extraneous survey datetime */
      modified_diet_end /* extraneous survey datetime */
      modified_diet_start /* extraneous survey datetime */
      modified_ess_end /* extraneous survey datetime */
      modified_ess_start /* extraneous survey datetime */
      modified_famhx_end /* extraneous survey datetime */
      modified_famhx_start /* extraneous survey datetime */
      modified_fosq_end /* extraneous survey datetime */
      modified_fosq_start /* extraneous survey datetime */
      modified_fss_end /* extraneous survey datetime */
      modified_fss_start /* extraneous survey datetime */
      modified_gad_end /* extraneous survey datetime */
      modified_gad_start /* extraneous survey datetime */
      modified_isi_end /* extraneous survey datetime */
      modified_isi_start /* extraneous survey datetime */
      modified_isq_end /* extraneous survey datetime */
      modified_isq_start /* extraneous survey datetime */
      modified_map_end /* extraneous survey datetime */
      modified_map_start /* extraneous survey datetime */
      modified_mdhx_end /* extraneous survey datetime */
      modified_mdhx_start /* extraneous survey datetime */
      modified_narc_end /* extraneous survey datetime */
      modified_narc_start /* extraneous survey datetime */
      modified_nose_end /* extraneous survey datetime */
      modified_nose_start /* extraneous survey datetime */
      modified_osa_end /* extraneous survey datetime */
      modified_osa_start /* extraneous survey datetime */
      modified_pap_end /* extraneous survey datetime */
      modified_pap_start /* extraneous survey datetime */
      modified_par_end /* extraneous survey datetime */
      modified_par_start /* extraneous survey datetime */
      modified_phq_end /* extraneous survey datetime */
      modified_phq_start /* extraneous survey datetime */
      modified_rls_end /* extraneous survey datetime */
      modified_rls_start /* extraneous survey datetime */
      modified_sched_end /* extraneous survey datetime */
      modified_sched_start /* extraneous survey datetime */
      modified_slpy_end /* extraneous survey datetime */
      modified_slpy_start /* extraneous survey datetime */
      modified_soclhx_end /* extraneous survey datetime */
      modified_soclhx_start /* extraneous survey datetime */
      modified_tab_end /* extraneous survey datetime */
      modified_tab_start /* extraneous survey datetime */

      /* recoded to numeric variable, re-add in next data step */
      sched_1401
      sched_1701
      sched_1801 
      soclhx_0101
      narc_1710

      /* remove variables that have numerical arrays, to reconfigure later */
      bthbts_0200
      bthbts_0400
      diet_0100
      diet_0200
      famhx_0110
      famhx_0210
      famhx_0310
      famhx_0410
      famhx_0510
      famhx_0610
      famhx_0710
      famhx_0810
      famhx_0910
      famhx_1010
      famhx_1110
      famhx_1210
      mdhx_0100
      mdhx_0120
      mdhx_0300
      mdhx_5730
      mdhx_5750
      mdhx_5830
      mdhx_5930
      mdhx_5960
      mdhx_6010
      mdhx_6020
      mdhx_6110
      mdhx_6210
      mdhx_6330
      mdhx_6410
      mdhx_6510
      mdhx_6530
      mdhx_6610
      mdhx_6620
      mdhx_6630
      mdhx_6640
      mdhx_6710
      mdhx_6720
      mdhx_6740
      mdhx_6760
      narc_0610
      narc_0710
      narc_0810
      narc_0910
      narc_1010
      pap_2000
      pap_2200
      soclhx_1100
      soclhx_1600
      ;
  run;

  data stages_final;
    set asq_merge;

    *create dummy visit variable;
    visitcode = 1;

    rename
      sched_1401_r = sched_1401
      sched_1701_r = sched_1701
      sched_1801_r = sched_1801
      soclhx_0101_r = soclhx_0101
      narc_1710_r = narc_1710
      ;
  run;

  * checking new smoking variables;
proc freq data=stages_final;
table   never_cigarette_smoker
		former_cigarette_smoker
		former_smokeless_user
		current_cigarette_smoker
		current_smokeless_user;
run;


*******************************************************************************;
* create harmonized datasets ;
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
	else if dem_1000 = 6 then nsrr_race = 'two races or some other race';

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

*******************************************************************************;
* checking harmonized datasets ;
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



*******************************************************************************;
* make all variable names lowercase ;
*******************************************************************************;
  options mprint;
  %macro lowcase(dsn);
       %let dsid=%sysfunc(open(&dsn));
       %let num=%sysfunc(attrn(&dsid,nvars));
       %put &num;
       data &dsn;
             set &dsn(rename=(
          %do i = 1 %to &num;
          %let var&i=%sysfunc(varname(&dsid,&i));    /*function of varname returns the name of a SAS data set variable*/
          &&var&i=%sysfunc(lowcase(&&var&i))         /*rename all variables*/
          %end;));
          %let close=%sysfunc(close(&dsid));
    run;
  %mend lowcase;

  %lowcase(stages_final);
  %lowcase(stages_harmonized);

  /*

  proc contents data=stages_nsrr_censored out=stages_nsrr_contents;
  run;

  proc freq data=stages_final;
    table rls_0801;
  run;

  */

*******************************************************************************;
* create permanent sas datasets ;
*******************************************************************************;
  data stagesd.stages stagesa.stages_&sasfiledate;
    set stages_final;
  run;

*******************************************************************************;
* export nsrr csv datasets ;
*******************************************************************************;
  proc export data=stages_final
    outfile="&releasepath\&version\stages-dataset-&version..csv"
    dbms=csv
    replace;
  run;

    proc export data=stages_harmonized
    outfile="&releasepath\&version\stages_harmonized-&version..csv"
    dbms=csv
    replace;
  run;

