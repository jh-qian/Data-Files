/*Always check for logical inconsistencies in routinely collected data. When records appear inconsistent, */
/*it is usual practice to delete all records for that case. An example is when there is an apparent contradiction */
/*between two sources of data, potentially due to a linkage error or possibly due to boundary problems such as a */
/*patient leaving NSW*/
/**/
/*To do this, we need to flag the inconsistent record, and then make sure that all records for that case are also */
/*flagged for deletion. For example, if we are merging a death file with patient admission records, we could flag */
/*any inconsistent death records of the type described above in the merged file by outputting it to a new file, */
/*dodgydeath, as follows*/


/*Extract inconsistent death records*/

DATA dodgydeath (KEEP=ppn episode_start_date episode_end_date mode_of_separation_recode death_date dodgyflag); 
	SET merged;
*mode_of_separation_recode=death with autopsy and no linked death record; 
	IF mode_of_separation_recode='6' AND death_date = . THEN DO; 
		dodgyflag=1; OUTPUT; 
	END;
*mode_of_separation_recode=death without autopsy and no linked death record; 
	IF mode_of_separation_recode='7' AND death_date = . THEN DO; 
		dodgyflag=2; OUTPUT; 
	END;
* 8c: date of death < date of admission; 
	ELSE IF death_date NE . AND death_date < episode_start_date THEN DO; 
		dodgyflag=3; OUTPUT; 
	END;
* 8d: date of death < date of separation; 
	ELSE IF death_date NE . AND death_date < episode_end_date AND episode_end_date NE death_date+1 THEN DO; 
		dodgyflag=4; OUTPUT; 
	END; 
RUN;

PROC FREQ DATA=dodgydeath; 
	TABLE dodgyflag; 
RUN;

PROC SORT DATA=dodgydeath; 
	BY dodgyflag; 
RUN;

PROC PRINT DATA=dodgydeath NOOBS N; 
	VAR ppn episode_start_date episode_end_date mode_of_separation_recode death_date; 
	BY dodgyflag; 
	FORMAT episode_start_date episode_end_date death_date ddmmyy10.; 
RUN;


/*Also check for other types of inconsistency and assign these a different value of dodgyflag so that we can */
/*inspect the records for the different types of inconsistency. We must then merge the dodgyflag back onto the merged file, */
/*so that all records for that patient are flagged for deletion. We can then print relevant variables for all the flagged */
/*records to see if we can spot a problem*/

/*Merge dodgyflag back onto data*/
PROC SORT DATA=dodgydeath; 
	BY ppn; 
RUN;

DATA merged2; 
	MERGE merged dodgydeath (KEEP=ppn dodgyflag); 
	BY cppn; 
RUN;
PROC PRINT DATA=merged2 NOOBS; 
	VAR cvd_ppn episode_start_date episode_end_date death_date mode_of_separation_recode dodgyflag; 
	FORMAT episode_start_date episode_end_date death_date ddmmyy10.; 
	WHERE dodgyflag NE .; 
RUN;

/*Delete all records with dodgy death dates*/

DATA mydata.apdcfinal (COMPRESS=CHAR DROP=dodgyflag); 
	SET merged2; 
	WHERE dodgyflag =.;
RUN;

