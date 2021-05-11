/*A SAS array is a group of variables to which we wish to apply identical operations in a DATA step. */
/*For example, the CVD data contains 51 ICD10 diagnosis codes: diagnosis_codeP (corresponding to the principal diagnosis), */
/*and diagnosis_code1 to diagnosis_code50 (corresponding to additional diagnoses).*/

/*Self Harm Example*/
DATA apdc_1;
	SET apdc;
	self_harm = 0
	/*Define ICD as an array containing the 51 ICD variables*/
	ARRAY icd diagnosis_codeP -- diagnosis_code50;

	/*Identify any record that contains a self-harm diagnosis*/
	DO i=1 TO dim(icd);
		IF icd[i] IN ("X60", "X61", "X62", "X63", "X64", "X65", "X66", "X67",
		"X68", "X69", "X70", "X71", "X72", "X73", "X74", "X75", "X76", "X77",
		"X78", "X79", "X80", "X81", "X82", "X83", "X84", "Y87.0") THEN self_harm = 1;
	END;
	/*Drop counter variable i*/
	DROP i;
	/*Create yearsep variable as year of separation */
	yearsep=YEAR(episode_end_date);

RUN;




/*Check coding for self harm  and summarise yearsep */

PROC FREQ DATA = apdc_1; 
	TABLES self_harm yearsep; 
RUN;


/*Create self_harm_seq variable*/

DATA prevpool_1014_1; 
	SET prevpool_1014; 
	BY cvd_ppn; 
	RETAIN self_harm_seq;
	IF first.ppn THEN self_harm_seq=0; 
	IF self_harm =1 OR self_harm_seq>0 THEN self_harm_seq=self_harm_seq+1; 
RUN;


/*Mental Health Example*/

DATA apdc_1;
	SET apdc;

	/*Flag intentional self-harm, mental health, and substance use disorder diagnoses  */
	sh_diag = 0;
	mh_diag = 0;
	sud_diag = 0;
	/*Define ICD as an array containing the 51 ICD variables*/
	ARRAY icd diagnosis_codeP -- diagnosis_code50;

	/*Identify any record that contains a self-harm diagnosis*/
	DO i=1 TO dim(icd);
		IF "X60" <=: icd[i] <=: "X84" THEN sh_diag = 1;
		IF icd[i] IN ("Y87.0") THEN sh_diag = 1;
	END;

	/*Identify any records that contains a mental heath diagnosis*/
	DO i=1 TO dim(icd);
		IF "F00" <=: icd[i] <=: "F09" THEN mh_diag = 1;
		IF "F20" <=: icd[i] <=: "F99" THEN mh_diag = 1;
	END;

	/*Identify any records that contains a substance use disorder diagnosis*/
	DO i=1 TO dim(icd);
		IF "F10" <=: icd[i] <=: "F19" THEN sud_diag = 1;
	END;

	/*Drop counter variable i*/
	DROP i;

RUN;
