PROC FORMAT;
VALUE cogrp
1 ='Charlson=0'
2 ='Charlson=1,2'
3 ='Charlson>=3'
;

DATA filename;
   SET filename;

*Include the Charlson index for comorbidity;

ATTRIB charlson FORMAT=5. LENGTH=8 LABEL='Charlson score of comorbidities on
first hospitalisation';

ATTRIB cogrp FORMAT=cogrp. LENGTH=8 LABEL='Comorb group based on Charlson score';

ARRAY diags diagnosis_codeP--diagnosis_code50;

 *Loop through array looking for relevant diagnosis codes;
 *EACH TYPE HAS ITS OWN WEIGHT, AS WE NEED TO SUM THE WEIGHTS;
   DO i=1 TO 51;
 *ACUTE MYOCARDIAL INFARCTION; 
	 IF diags{i} IN: ('I21','I22')		 									THEN GRP1=1;
	 ELSE IF diags{i} IN: ('I25.2')		 									THEN GRP1=1;
 *CONGESTIVE HEART FAILURE;
	 IF diags{i} IN: ('I50') 												THEN GRP2=1;
 *PERIPHERAL VASCULAR DISEASE;
     IF diags{i} IN: ('I71','I79.0','I73.9','R02','Z95.8','Z95.9')		 	THEN GRP3=1;
 *CEREBRAL VASCULAR ACCIDENT;
	 IF 'I60' <=: diags{i} <=: 'I66' 										THEN GRP4=1;
	 ELSE IF 'I67.0' <=: diags{i} <=: 'I67.2' 								THEN GRP4=1;
	 ELSE IF 'I67.4' <=: diags{i} <=: 'I67.9' 								THEN GRP4=1;
	 ELSE IF diags{i} IN: ('I68.1','I68.2','I68.8','I69','G46')				THEN GRP4=1;
	 ELSE IF diags{i} IN: ('G45.0','G45.1','G45.2','G45.4','G45.8','G45.9') THEN GRP4=1;
 *DEMENTIA;
	 IF diags{i} IN: ('F00','F01','F02','F05.1')							THEN GRP5=1;
 *PULMONARY DISEASE;
	 IF  'J40' <=: diags{i} <=: 'J47' 										THEN GRP6=1;
	 ELSE IF  'J60' <=: diags{i} <=: 'J67' 									THEN GRP6=1;
 *CONNECTIVE TISSUE DISORDER;
	 IF  'M05.0' <=: diags{i} <=: 'M05.3' 									THEN GRP7=1;
	 ELSE IF  'M05.8' <=: diags{i} <=: 'M06.0' 								THEN GRP7=1;
	 ELSE IF diags{i} IN: ('M32','M34','M33.2','M06.3','M06.9','M35.3')		THEN GRP7=1;
 *PEPTIC ULCER;
	 IF  'K25' <=: diags{i} <=: 'K28' 										THEN GRP8=1;
 *LIVER DISEASE;
	 IF  'K74.2' <=: diags{i} <=: 'K74.6' 									THEN GRP9=1;
	 ELSE IF diags{i} IN: ('K70.2','K70.3','K71.7','K73','K74.0')	 		THEN GRP9=1;
 *DIABETES;
	 IF diags{i} IN: ('E10.9','E11.9','E13.9','E14.9')		 				THEN GRP10=1;
	 ELSE IF diags{i} IN: ('E10.1','E11.1','E13.1','E14.1')		 			THEN GRP10=1;
	 ELSE IF diags{i} IN: ('E10.5','E11.5','E13.5','E14.5')			 		THEN GRP10=1;
 *DIABETES COMPLICATIONS;
	 IF diags{i} IN: ('E10.2','E11.2','E13.2','E14.2')			 			THEN GRP11=2;
	 ELSE IF diags{i} IN: ('E10.3','E11.3','E13.3','E14.3')		 			THEN GRP11=2;
	 ELSE IF diags{i} IN: ('E10.4','E11.4','E13.4','E14.4')			 		THEN GRP11=2;
 *PARAPLEGIA;
	 IF  'G82.0' <=: diags{i} <=: 'G82.2' 									THEN GRP12=2;
	 ELSE IF diags{i} IN: ('G04.1','G81')	 								THEN GRP12=2;
 *RENAL DISEASE;
	 IF  'N05.2' <=: diags{i} <=: 'N05.6' 									THEN GRP13=2;
	 ELSE IF  'N07.2' <=: diags{i} <=: 'N07.4' 								THEN GRP13=2;
	 ELSE IF diags{i} IN: ('N01','N03','N18','N19','N25')   				THEN GRP13=2;
 *CANCER;
	 IF diags{i} IN: ('C40','C41','C43','C95','C96')						THEN GRP14=2;
	 ELSE IF  'C00' <=: diags{i} <=: 'C39' 									THEN GRP14=2;
	 ELSE IF  'C45' <=: diags{i} <=: 'C49' 									THEN GRP14=2;
	 ELSE IF  'C50' <=: diags{i} <=: 'C59' 									THEN GRP14=2;
	 ELSE IF  'C60' <=: diags{i} <=: 'C69' 									THEN GRP14=2;
	 ELSE IF  'C70' <=: diags{i} <=: 'C76' 									THEN GRP14=2;
	 ELSE IF  'C80' <=: diags{i} <=: 'C85' 									THEN GRP14=2;
	 ELSE IF diags{i} IN: ('C88.3','C88.7','C88.9','C90.0','C90.1','C94.7') THEN GRP14=2;
	 ELSE IF  'C91' <=: diags{i} <=: 'C93' 									THEN GRP14=2;
	 ELSE IF  'C94.0' <=: diags{i} <=: 'C94.3' 								THEN GRP14=2;
	 ELSE IF  diags{i} = 'C94.51'								 			THEN GRP14=2;
 *METASTATIC CANCER;
	 IF  'C77' <=: diags{i} <=: 'C80' 										THEN GRP15=6;
 *SEVERE LIVER DISEASE;
	 IF diags{i} IN: ('K72.9','K76.6','K76.7','K72.1')				 		THEN GRP16=3;
 *HIV;
	 IF  'B20' <=: diags{i} <=: 'B24' 										THEN GRP17=6;

   END;

* Calculate Charlson Index by summing the weights;
   charlson=SUM(OF GRP1-GRP17); 
   IF charlson='' THEN charlson=0;

* Create categories of Charlson Index;
   IF charlson GE 3 THEN cogrp=3;
   ELSE IF 1 LE charlson LE 2 THEN cogrp=2;
	  ELSE cogrp=1;
RUN;
