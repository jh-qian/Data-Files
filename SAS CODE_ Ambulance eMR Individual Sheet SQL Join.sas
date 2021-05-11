proc sql;
   create table work.TEST as
   select
      AMBO_EMR_MAIN.EPCR_ID length = 8   
         format = BEST32.
         informat = BEST32.,
      AMBO_EMR_MAIN.CASE_DATE length = 8   
         format = DATETIME.
         informat = ANYDTDTM40.,
      year(datepart(AMBO_EMR_MAIN.CASE_DATE )) as CASE_YEAR length = 8   
         format = BEST32.
         informat = BEST32.,
      AMBO_EMR_MAIN.CASE_NUMBER length = 8   
         format = BEST32.
         informat = BEST32.,
      AMBO_EMR_MAIN.PT_RCD_ID length = 8   
         format = BEST32.
         informat = BEST32.,
      AMBO_EMR_MAIN.CASE_GIVEN_AS length = 50   
         format = $50.
         informat = $50.,
      AMBO_EMR_MAIN.GENDER length = 13   
         format = $13.
         informat = $13.,
      AMBO_EMR_MAIN.YEAR_AGE length = 8   
         format = BEST32.
         informat = BEST32.,
      AMBO_EMR_PRE_EXISTING.PREEXISTING_CONDITION_NAME length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_PRE_EXISTING.PREEXISTING_CONDITION_SUMMARY length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_CASE_NATURE.CASE_NATURE_NAME length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_CASE_NATURE.CASE_NATURE_SUMMARY length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_CASE_DESCRIPTION.CASE_DESCRIPTION length = 2000   
         format = $2000.
         informat = $2000.,
      AMBO_EMR_COMPLAINT.COMPLAINT_NAME length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_COMPLAINT.COMPLAINT_SUMMARY length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_PRIMARY_SURVEY.PRIMARY_SURVEY_NAME length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_PRIMARY_SURVEY.PRIMARY_SURVEY_SUMMARY length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_SECONDARY_SURVEY.SECONDARY_SURVEY_NAME length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_SECONDARY_SURVEY.SECONDARY_SURVEY_SUMMARY length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_ASSESSMENT.ASSESSMENT_NAME length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_ASSESSMENT.ASSESSMENT_SUMMARY length = 3000   
         format = $3000.
         informat = $3000.,
      AMBO_EMR_PROTOCOLS.PROTOCOL_1 length = 6   
         format = $PROTOCOLS.
         informat = $6.,
      AMBO_EMR_PROTOCOLS.PROTOCOL_2 length = 6   
         format = $PROTOCOLS.
         informat = $6.,
      AMBO_EMR_PROTOCOLS.PROTOCOL_3 length = 6   
         format = $PROTOCOLS.
         informat = $6.,
      AMBO_EMR_PROTOCOLS.PROTOCOL_4 length = 6   
         format = $PROTOCOLS.
         informat = $6.,
      AMBO_EMR_PROTOCOLS.PROTOCOL_5 length = 6   
         format = $PROTOCOLS.
         informat = $6.,
      AMBO_EMR_PROTOCOLS.PROTOCOL_6 length = 6   
         format = $PROTOCOLS.
         informat = $6.,
      AMBO_EMR_PROTOCOLS.PROTOCOL_7 length = 6   
         format = $PROTOCOLS.
         informat = $6.
   from
      SPNSW_LN.AMBO_EMR_MAIN as AMBO_EMR_MAIN left join 
      SPNSW_LN.AMBO_EMR_PRE_EXISTING as AMBO_EMR_PRE_EXISTING
         on
         (
            AMBO_EMR_MAIN.EPCR_ID = AMBO_EMR_PRE_EXISTING.EPCR_ID
         ) left join 
      SPNSW_LN.AMBO_EMR_CASE_NATURE as AMBO_EMR_CASE_NATURE
         on
         (
            AMBO_EMR_MAIN.EPCR_ID = AMBO_EMR_CASE_NATURE.EPCR_ID
         ) left join 
      SPNSW_LN.AMBO_EMR_CASE_DESCRIPTION as AMBO_EMR_CASE_DESCRIPTION
         on
         (
            AMBO_EMR_MAIN.EPCR_ID = AMBO_EMR_CASE_DESCRIPTION.EPCR_ID
         ) left join 
      SPNSW_LN.AMBO_EMR_COMPLAINT as AMBO_EMR_COMPLAINT
         on
         (
            AMBO_EMR_MAIN.EPCR_ID = AMBO_EMR_COMPLAINT.EPCR_ID
         ) left join 
      SPNSW_LN.AMBO_EMR_PRIMARY_SURVEY as AMBO_EMR_PRIMARY_SURVEY
         on
         (
            AMBO_EMR_MAIN.EPCR_ID = AMBO_EMR_PRIMARY_SURVEY.EPCR_ID
         ) left join 
      SPNSW_LN.AMBO_EMR_SECONDARY_SURVEY as AMBO_EMR_SECONDARY_SURVEY
         on
         (
            AMBO_EMR_MAIN.EPCR_ID = AMBO_EMR_SECONDARY_SURVEY.EPCR_ID
         ) left join 
      SPNSW_LN.AMBO_EMR_ASSESSMENT as AMBO_EMR_ASSESSMENT
         on
         (
            AMBO_EMR_MAIN.EPCR_ID = AMBO_EMR_ASSESSMENT.EPCR_ID
         ) left join 
      SPNSW_LN.AMBO_EMR_PROTOCOLS as AMBO_EMR_PROTOCOLS
         on
         (
            AMBO_EMR_MAIN.EPCR_ID = AMBO_EMR_PROTOCOLS.EPCR_ID
         )
   ;
quit;