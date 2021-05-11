/*The LAG function creates a new reference date field (“Ref_Date”) by retrieving the value of the discharge date from the previous line. */
/*On each line, the gap between the current admission date and the immediate previous discharge date (“Gap”) would be calculated and*/
/*evaluated. A readmission indicator field (“Tag”) would be created and if the gap is no more than 30 days, a value of 1 would be assigned */
/*to this field. The field “Readmissions” is the cumulative sum of “Tag” and shows how many readmissions for this patient have been tallied */
/*up to this point. */

/*Each time when SAS first encounters the claims data of a new patient, all four new fields (“Ref_Date”, “Gap”, “Tag”, and “Readmissions”) */
/*would be reset to missing values, and a fresh round of tallying would start for the new patient.*/

/*30 day readmission example */

DATA apdc_1;
 SET apdc;
 BY id fileseq;
 ref_date = LAG(discharge_date); * Retrieve the value of the previous discharge date;
 FORMAT ref_date YYMMDD10.;
 LABEL ref_date = “Reference Date”;
 gap = admission_date - ref_date; * Calculate the gap between the current admission date and the previous discharge date;
 IF first.id THEN DO; *Reset the values of the following fields in case of a new patient ID;
 ref_date = .;
 gap = .;
 tag = .;
 readmissions = .;
 END;
 IF 0 <= gap <= 30 THEN tag = 1; * Identify a readmission and assign value 1 to Tag;
 Readmissions + Tag; *Calculate cumulative readmissions;
RUN;

/*Note that when SAS executes the statement “Readmissions + Tag ;”, it adds the value of “Tag” to the value of*/
/*“Readmissions” and retains the new value until the next processing of the statement. This running total has to be*/
/*reset to a missing value when SAS processes the data for the next new patient ID.*/