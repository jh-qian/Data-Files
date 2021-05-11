proc import datafile="F:\BDI\BDISP\ETL\10_NSW\1000_Source_Data\AMBULANCE\eMR - 6 Primary Survey.csv"
        out=PRISURVEY_1
        dbms=csv
        replace;
     	getnames=yes;
		delimiter = '|';
		
run;

proc sort data=PRISURVEY_1;
by EPCR_ID  display_sequence;
run;

proc transpose data= PRISURVEY_1 
	out= PRISURVEY_SUMM (drop=_NAME_)
	prefix=pri_survey_summ_;
	by EPCR_ID;
	id DISPLAY_SEQUENCE;
	var PRIMARY_SURVEY_SUMMARY;
run;


proc transpose data= PRISURVEY_1
	out= PRISURVEY_NAME (drop=_NAME_)
	prefix=pri_survey_name_;
	by EPCR_ID;
	id DISPLAY_SEQUENCE;
	var PRIMARY_SURVEY_NAME;
run;




proc sql;
   create table WORK.PRI_SURVEY_TRANS as 
   select t1.EPCR_ID, 
          t1.pri_survey_name_1, 
          t1.pri_survey_name_2, 
          t1.pri_survey_name_3, 
          t1.pri_survey_name_4, 
          t1.pri_survey_name_5, 
          t1.pri_survey_name_6, 
          t1.pri_survey_name_7, 
          t1.pri_survey_name_8, 
          t1.pri_survey_name_9, 
          t1.pri_survey_name_10, 
          t1.pri_survey_name_11, 
          t1.pri_survey_name_12, 
          t1.pri_survey_name_13, 
          t1.pri_survey_name_14, 
          t2.pri_survey_summ_1, 
          t2.pri_survey_summ_2, 
          t2.pri_survey_summ_3, 
          t2.pri_survey_summ_4, 
          t2.pri_survey_summ_5, 
          t2.pri_survey_summ_6, 
          t2.pri_survey_summ_7, 
          t2.pri_survey_summ_8, 
          t2.pri_survey_summ_9, 
          t2.pri_survey_summ_10, 
          t2.pri_survey_summ_11, 
          t2.pri_survey_summ_12, 
          t2.pri_survey_summ_13, 
          t2.pri_survey_summ_14
      from WORK.PRISURVEY_NAME t1
           inner join WORK.PRISURVEY_SUMM t2 on (t1.EPCR_ID = t2.EPCR_ID);
quit;