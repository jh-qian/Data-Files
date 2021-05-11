/*Sequence variables are used commonly when working with linked data. Sequence variables are sequences (or counts) based on records meeting certain criteria, */
/*and are generated in the EOR loading area. Three commonly used sequences are fileseq, morbseq and indexseq. */
/*While more sequence variables can be (and often are) generated, the three sequences above are generated for most analyses of linked data.*/
/**/
/*The first of these sequences, fileseq, numbers all records in a set of data sequentially from the first to the last. */
/*The morbseq or morbidity sequence variable is defined as 1 for the first record within an individual, and increases by 1 */
/*for each subsequent record for that individual. Finally the indexseq variable is defined as 1 for the first record of an */
/*individual corresponding to a certain condition (the "index" condition), increasing by 1 for all subsequent records. */
/*All records prior to the index condition can be assigned a value of 0.*/

/*Sort data by ID and visitdate*/

PROC SORT DATA=visits;
BY id visit;
RUN;

DATA visitseq;
SET visits;
BY id;
/*Assign fileseq*/
fileseq = _n_;
/*Assign morbseq*/
RETAIN morbseq;
IF first.id THEN morbseq=0;
morbseq=morbseq+1;
RUN;

/*In order to generate an indexseq, a target condition is required. For example, if we wanted to create an indexseq in the VISITS data */
/*based on a systolic blood pressure of 140mmHg or higher, the target condition would be: sbp≥140*/

/*The general procedure of creating an index sequence is as follows:*/

/*1. Set the index sequence to zero for the first record within an individual.*/
/*2. Create a temporary flag variable to identify observations where the target condition is met.*/
/*3. Increase the index sequence by a value of 1 for the first record where the target condition has been met (i.e. the index record) */
/*or any record subsequent to the index record (i.e. if the indexseq is already > 0).*/
/*4. Delete the temporary flag variable using the DROP command.*/

/*Sort data by ID and visitdate*/

PROC SORT DATA=visits;
BY id visit;
RUN;

DATA visitseq;
	SET visit;
	BY id;
/*	Assign fileseq*/
	fileseq = _n_;
/*	Assign morbseq*/
	RETAIN morbseq;
	IF first.id THEN morbseq=0;
	morbseq=morbseq+1;
/*	Assign indexseq*/
	RETAIN indexseq;
	IF first.id THEN indexseq=0;
	IF sbp >= 140 THEN flag=1;
	IF flag=1 OR indexseq>0 THEN indexseq=indexseq+1;
/*	Drop the temporary FLAG variable*/
	DROP flag;
RUN;

/*There is some benefit in setting pre-index records to negative numbers: either all -1, or counting backwards from -1.*/
/*The following SAS code replaces the zeros in a previously constructed index with a negative sequence from -1 for all */
/*individuals satisfying the index condition.*/

/*Create negative indexseq First sort VISITSEQ in upside-down order*/

PROC SORT DATA=visitseq;
	BY DESCENDING id DESCENDING fileseq;
RUN;


DATA visitseq2;
	SET visitseq;
	BY DESCENDING id;
	RETAIN index_temp;
	IF first.id THEN index_temp=.;
	* Set index_temp to a flag of 1 for post-index records;
	IF indexseq ne 0 THEN index_temp=1;
	* Set index_temp to -1 for the first pre-index record;
	IF indexseq=0 AND index_temp=1 THEN index_temp=-1;
	* Count by -1 for subsequent pre-index records;
	ELSE IF index_temp<0 THEN index_temp=index_temp-1;
	* Replace indexseqs of 0 with negative sequence;
	IF indexseq=0 AND index_temp NE . THEN indexseq=index_temp;
	DROP index_temp;
RUN;

PROC SORT DATA=visitseq2;
	BY fileseq;
RUN;