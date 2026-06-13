*******************************************************************************;
* Adapted from scripts/prepare-stages-for-nsrr.sas (nsrr/stages-data-dictionary);
* Author of original: Michael Rueschman (mnr), National Sleep Research Resource ;
* Section: MERGE of the three ASQ survey exports, the per-variable recodes, and ;
* the INDEX()-based derivation of binary cigarette/smokeless smoking variables  ;
* from soclhx_1100. Source datasets are provided by the bundle autoexec.        ;
*******************************************************************************;

  data asq_merge;
    merge
      asq_dem_in
      asq_isi_in
      asq_202207_in
      ;
    by subject_code survey_id;

    *recode morningness/eveningness question to match data dictionary (per KC from STAGES group July 2022);
    if cir_0600 = 5 then cir_0600 = 6;

    *recode isq_score (per KC from STAGES group July 2022);
    if isq_score = '' then isq_score = '0';
    else if isq_score = '-1' then isq_score = '';

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

    *correct spelling;
    if rls_probability = "Unlikely (possibly IN past)" then rls_probability = "Unlikely (possibly in past)";

    *creating binary smoking variables from soclhx_1100;
    format never_cigarette_smoker 8.0;
    if index(soclhx_1100, '0') then never_cigarette_smoker = 1;
    else if soclhx_1100 ne '' then never_cigarette_smoker= 0;

    format former_cigarette_smoker 8.0;
    if index(soclhx_1100, '1') then former_cigarette_smoker = 1;
    else if soclhx_1100 ne '' then former_cigarette_smoker = 0;

    format former_smokeless_user 8.0;
    if index(soclhx_1100, '2') then former_smokeless_user = 1;
    else if soclhx_1100 ne '' then former_smokeless_user = 0;

    format current_cigarette_smoker 8.0;
    if index(soclhx_1100, '3') then current_cigarette_smoker = 1;
    else if soclhx_1100 ne '' then current_cigarette_smoker = 0;

    format current_smokeless_user 8.0;
    if index(soclhx_1100, '4') then current_smokeless_user = 1;
    else if soclhx_1100 ne '' then current_smokeless_user = 0;

    *remove variables systematically;
    drop
      survey_id /* administrative variable */

      /* recoded to numeric variable, re-add in next data step */
      sched_1401
      sched_1701
      sched_1801
      soclhx_0101
      narc_1710

      /* remove variables that have numerical arrays, to reconfigure later */
      soclhx_1100
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

proc print data=stages_final;
  var subject_code visitcode never_cigarette_smoker current_cigarette_smoker
      sched_1401 narc_1710 rls_probability;
run;
