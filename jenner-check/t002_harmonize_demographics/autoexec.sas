*******************************************************************************;
* autoexec for t002_harmonize_demographics                                    ;
* options obs=100 bounds output. A stand-in stages_final dataset supplies the  ;
* columns the harmonization DATA step reads, so the NSRR demographic           ;
* derivation from prepare-stages-for-nsrr.sas runs alone. Values for           ;
* dem_0500/dem_1000/dem_0900 follow the data dictionary domains.               ;
*******************************************************************************;
options obs=100 nofmterr;

data stages_final;
  length subject_code $12 dem_0500 $1;
  input subject_code $ dem_0500 $ dem_1000 dem_0900 modified_dem_0110 dem_0800
        current_cigarette_smoker former_cigarette_smoker;
  datalines;
STAGES0001 M 1 0 34 24.3 0 0
STAGES0002 F 2 1 58 31.7 1 1
STAGES0003 M 4 0 91 27.0 1 0
STAGES0004 F 0 . 45 22.1 0 1
STAGES0005 M 6 0 67 29.9 0 0
;
run;
