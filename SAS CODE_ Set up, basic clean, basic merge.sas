/*LIBNAME to create a read-only SAS library for CHeReL data, and a library for data set formats*/

LIBNAME mydata 'C:\data' ACCESS=READONLY;

/*To avoid errors with incompatible formats, the following line of code can optionally be included */

OPTIONS NOFMTERR FMTSEARCH=(library);


/*Create working copies of the datasets. Using working copies of tables does not overwrite the original source file.  */

DATA apdc; 
SET mydata.apdc; 
RUN;

DATA cod_urf; 
SET mydata.cod_urf; 
RUN;

/*Use PROC CONTENTS to examine contents of the work table datasets*/

PROC CONTENTS DATA=apdc VARNUM; 
RUN;

PROC CONTENTS DATA=cod_urf VARNUM; 
RUN;

* Rename the common variable age_recode in both data sets; 

DATA apdc_1; 
SET apdc; 
RENAME age_recode = age_admission; 
RUN;

DATA cod_urf_1; 
SET cod_urf; 
RENAME age_recode = age_death; 
RUN;

/*Examine date fields for formatting; */

PROC PRINT DATA=apdc_1 (OBS=10); 
VAR lifespan_ppn episode_start_date episode_end_date; 
RUN;

PROC PRINT DATA=cod_urf_1 (OBS=10); 
VAR lifespan_ppn death_date; 
RUN;

/*Check for PPN with multiple records of death*/

DATA cod_urf_2; 
SET cod_urf_1; 
BY lifespan_ppn; 
IF first.lifespan_ppn NE last.lifespan_ppn; 
RUN;

/*Remove incorrect records from cod_urf using an IF THEN DELETE. Note: These records will not be deleted from the CHeReL source*/

DATA cod_urf_clean; 
SET cod_urf_2; IF lifespan_ppn=6043 AND death_date="01DEC2013"D THEN DELETE; 
RUN;


/*Alternatively, can also delete the first record by using an IF statement to keep the LAST record */

DATA cod_urf_clean; 
SET cod_urf_2; 
BY lifespan_ppn; 
IF last.lifespan_ppn;
RUN;


/*Sort the files, then merge COD URF deaths onto the APDC data; */

PROC SORT DATA=apdc_1; 
BY lifespan_ppn; 
RUN;

PROC SORT DATA=cod_urf_clean; 
BY lifespan_ppn death_date; 
RUN;

DATA merged; 
MERGE apdc_1 cod_urf_clean; 
BY lifespan_ppn; 
RUN;

/*Merge the data, examine the log, and then generate cross-tabulations;*/

DATA merged; 
MERGE apdc_1 (IN=ina) cod_urf_clean (IN=inb); BY lifespan_ppn;
lsapdc=ina; lscodurf=inb; RUN;

PROC FREQ DATA=merged; 
TABLE lsapdc*lscodurf / NOCOL NOROW NOPERCENT; 
RUN;
