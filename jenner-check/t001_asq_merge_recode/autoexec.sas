*******************************************************************************;
* autoexec for t001_asq_merge_recode                                          ;
* options obs=100 bounds output -- the three source ASQ datasets are mocked   ;
* in place of the upstream PROC IMPORT of deidentified XLSX exports, so that   ;
* the MERGE and recode logic from prepare-stages-for-nsrr.sas runs alone.     ;
* Column shapes follow the STAGES data dictionary (variables/, domains/).     ;
*******************************************************************************;
options obs=100 nofmterr;

*---- stand-in for asq_dem_in (DEM..SLPY export) ----;
data asq_dem_in;
  length subject_code $12 dem_0500 $1 soclhx_1100 $8;
  input subject_code $ survey_id dem_0500 $ dem_0800 dem_0900 dem_1000
        modified_dem_0110 cir_0600 isq_score $ soclhx_1100 $;
  datalines;
STAGES0001 1 M 24.3 0 1 34 5 12 0
STAGES0002 1 F 31.7 1 2 58 6 . 13
STAGES0003 1 M 27.0 0 4 91 5 -1 34
STAGES0004 1 F 22.1 . 0 45 5 . .
STAGES0005 1 M 29.9 0 6 67 6 12 01
;
run;

*---- stand-in for asq_isi_in (ISI..DIET export) ----;
data asq_isi_in;
  length subject_code $12 sched_1401 $5 sched_1701 $5 sched_1801 $5
         soclhx_0101 $5 narc_1710 $2;
  input subject_code $ survey_id sched_1401 $ sched_1701 $ sched_1801 $
        soclhx_0101 $ narc_1710 $;
  datalines;
STAGES0001 1 true false true false 7
STAGES0002 1 false true false true 3
STAGES0003 1 true true true false 11
STAGES0004 1 false false true false 5
STAGES0005 1 true false false true 9
;
run;

*---- stand-in for asq_202207_in (RLS Revised Section) ----;
data asq_202207_in;
  length subject_code $12 rls_probability $40;
  input subject_code $ survey_id rls_probability $40.;
  datalines;
STAGES0001 1 Unlikely (possibly IN past)
STAGES0002 1 Likely
STAGES0003 1 Unlikely (possibly IN past)
STAGES0004 1 Unknown
STAGES0005 1 Likely
;
run;
