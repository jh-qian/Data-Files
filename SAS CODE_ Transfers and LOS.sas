/*Code that can identify cases of serial, overlapping and nested transfers, */
/*single-day transfers on the last day of stay, and type-change separations. */
/*Identifying all these types of separation is necessary to correctly calculate */
/*length of stay.*/

DATA apdcX70;
	SET mydata.apdc;
		WHERE diagnosis_codeP ='X70';
RUN;


/*Note that the following code requires the data set be sorted by episode start date and */
/*episode end date within the person project number*/

PROC SORT DATA=apdcX70;
	BY ppn episode_start_date episode_end_date;
RUN;
DATA apdcX70_trans;
	SET apdcX70;
	BY cvd_ppn;
	RETAIN morbseq stayseq;
/*	Generate FILESEQ and MORBSEQ*/
	fileseq=_n_;
	IF first.cvd_ppn THEN morbseq=0;
	morbseq=morbseq+1;
/*	Identify nested transfers and populate the start date, end date and final sepmode of nested transfers*/
	RETAIN nest_start nest_end nest_sepmode nested;
	IF morbseq=1 THEN DO;
		nest_start=episode_start_date;
		nest_end=episode_end_date;
		nest_sepmode=mode_of_separation_recode;
		nested=0;
		stayseq=0;
	END;
	IF morbseq>1 AND (episode_start_date <= nest_end & episode_end_date <= nest_end) THEN nested=nested+1;
	ELSE DO;
		nest_start= episode_start_date;
		nest_end= episode_end_date;
		nest_sepmode= mode_of_separation_recode;
		nested=0;
	END;
	* Create lag variables;
	lagsep = LAG(nest_end);
	lagsepmode = LAG(nest_sepmode);
	IF morbseq=1 THEN DO;
		lagsep=.; lagsepmode=.;
	END;
/*	Identify transfers as those with multiple records*/
/*	(i.e. morbseq>1)*/
/*	AND admission date before previous separation date*/
/*	(i.e. overlapping transfer)*/
/*	OR admission date before the initial record's separation date*/
/*	(i.e. nested transfer)*/
/*	OR transferred to another hospital(mode_of_separation_recode=5) AND episode_start_date=previous episode_end_date (i.e. serial transfer)*/
/*	OR type-change separation (mode_of_separation_recode=9)*/
/*	AND episode_start_date=previous episode_end_date (i.e. type-change)*/

	IF morbseq>1 AND ((nested>0) OR (episode_start_date < lagsep)
		OR (lagsepmode IN (5,9) and (episode_start_date = lagsep)))
	THEN transseq+1;
	ELSE DO;
		transseq=0;
		stayseq=stayseq+1;
	END;
	DROP nest_start nest_end lagsep lagsepmode nest_sepmode nested;
RUN;

/*Whenever you run code such as this, you should check it first on a subset of your data */
/*(focussing on variables such as ppn, episode_start_date, episode_end_date, mode_of_separation_recode and transseq) */
/*to check that transfers are identified as expected. Note that some very complicated sets of transfers may not */
/*be picked up correctly using the above syntax*/

/*Ignoring transfers and type-changes affects length-of-stay calculations. The code below generates two variables for length of stay: */
/*losd and totlos, which ignore and account for transfers and type-changes respectively. The variable totlos is created by calculating sepdate_fin, */
/*which accounts for transfers and type-changes when calculating length of stay. Note also that, by convention, same-day admissions, */
/*i.e. stays for which the admission date is the same as the separation date, are given a length of stay of 1*/

/*Create SEPDATE_FIN, and populate it to the all admissions in a transfer set*/
/*Use upside-down data*/

PROC SORT DATA=apdcX70_trans;
BY DESCENDING ppn DESCENDING fileseq;
RUN;
DATA apdcX70_length;
	SET apdcX70_trans;
	BY DESCENDING ppn DESCENDING fileseq;
	RETAIN date_tmp flag;
	IF first.cvd_ppn THEN DO;
		date_tmp=.; flag=.;
	END;
	IF transseq NE 0 THEN DO;
		IF date_tmp=. THEN DO;
			flag=1;
			date_tmp=episode_end_date;
		END;
	ELSE date_tmp=max(episode_end_date, date_tmp);
	END;
	ELSE IF transseq=0 AND flag=1 THEN DO;
		sepdate_fin_tmp=max(episode_end_date, date_tmp);
		flag=.; date_tmp=.;
		END;
	ELSE IF transseq=0 THEN sepdate_fin_tmp=episode_end_date;
	DROP flag date_tmp;
RUN;
/*Turn data right-way up*/

PROC SORT DATA=apdcX70_length;
BY ppn fileseq stayseq;
RUN;

/*Populate sepdate_fin to all records within a stay*/
DATA apdcX70_los;
	SET apdcX70_length;
	BY ppn stayseq;
	RETAIN sepdate_fin;
	IF first.stayseq THEN sepdate_fin=sepdate_fin_tmp;
	FORMAT sepdate_fin ddmmyy10.;
	/*Construct LOS variables*/
	losd = episode_end_date - episode_start_date;
	IF losd = 0 THEN losd = 1;
	totlos = sepdate_fin - episode_start_date;
	IF totlos = 0 THEN totlos = 1;
	DROP sepdate_fin_tmp;
RUN;

/*Summarise length of stay*/
PROC MEANS DATA=apdcX70_los;
	VAR losd totlos;
	WHERE transseq=0;
RUN;