
data apdc (drop= i);
  set NSW_APDC.NSW_APDC (rename=(diagnosis_codes_sec=diagnosis_code));
  array diagnosis_codes_sec(50) $200;
  i=1;
  do until (scan(diagnosis_code,i,"|") eq "");
    diagnosis_codes_sec(i)=scan(diagnosis_code,i,"|");
    i+1;
  end;

run;

/*proc sql noprint;*/
/*select max(countw(diagnosis_codes_sec,'|')) into : n from NSW_APDC.NSW_APDC ;*/
/*quit;*/
/*data test;*/
/* set NSW_APDC.NSW_APDC;*/
/* array var_{&n} $ 40;*/
/* do i=1 to countw(diagnosis_codes_sec,'|');*/
/*  var_{i}=scan(diagnosis_codes_sec,i,'|');*/
/* end;*/
/* drop i ;*/
/*run;*/