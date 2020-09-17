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
  run;

  data stages_final;
    set asq_merge;
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
    table narc_1620;
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
