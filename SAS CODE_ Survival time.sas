/*For observations with hospitalisation records, code to calculate the time (in days) between the last separation date and death*/

PROC SORT DATA=merged; 
BY lifespan_ppn episode_end_date; 
RUN;

DATA survival; 
SET merged; 
BY lifespan_ppn episode_end_date;
IF last.lifespan_ppn THEN lastsep=1; 
survtime = death_date - episode_end_date; 
yearsep = year(episode_end_date); 
RUN;

PROC PRINT DATA=survival NOOBS; 
VAR lifespan_ppn episode_start_date episode_end_date yearsep death_date survtime; 
WHERE lastsep=1 AND survtime NE .; 
RUN;

PROC FREQ DATA=survival; 
TABLE yearsep; 
WHERE lastsep=1 AND survtime NE .; 
RUN;