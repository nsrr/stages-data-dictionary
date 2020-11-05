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
  %let version = 0.1.0.pre;

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
      pap_2000
      pap_2200
      soclhx_1100
      soclhx_1600
      ;
  run;

  data stages_final;
    set asq_merge;

    rename
      sched_1401_r = sched_1401
      sched_1701_r = sched_1701
      sched_1801_r = sched_1801
      soclhx_0101_r = soclhx_0101
      narc_1710_r = narc_1710
      ;
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
