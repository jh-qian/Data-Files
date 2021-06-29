//The quintiles are calculated as follows: the lowest scoring 20% of areas are given a quintile number of 1, the second-lowest 20% of areas are given a quintile number of 2 and so on, up to the highest 20% of areas which are given a quintile number of 5. The quintiles used for these maps are area-based, which means that the quintiles contain equal numbers of areas. They do not necessarily contain equal numbers of people or dwellings. ref:https://www.abs.gov.au/ausstats/abs@.nsf/Lookup/2033.0.55.001main+features72016/////

use "LifeSpan_Intervention_Site_Boundaries_SA2.dta"
merge 1:1 GEO_CODE using "SEIFA_IRSAD.dta"
keep if _merge==3
drop _merge

*****Newcastle***********
keep if SITE_NAME=="Newcastle (LifeSpan)"
sort SCORE 
xtile SCORE_quart = SCORE , nq(5)

foreach x of numlist 1/5 {
	summary SCORE if SCORE_quart==`x'
}


*****repeat for the rest of trials***
***Illawarra Shoalhaven *************

use "LifeSpan_Intervention_Site_Boundaries_SA2.dta"
merge 1:1 GEO_CODE using "SEIFA_IRSAD.dta"
keep if _merge==3
drop _merge

keep if SITE_NAME=="Illawarra Shoalhaven (LifeSpan)"
sort SCORE 
xtile SCORE_quart = SCORE , nq(5)

foreach x of numlist 1/5 {
	summary SCORE if SCORE_quart==`x'
}



**********Central Coast**************
use "LifeSpan_Intervention_Site_Boundaries_SA2.dta"
merge 1:1 GEO_CODE using "SEIFA_IRSAD.dta"
keep if _merge==3
drop _merge

keep if SITE_NAME=="Central Coast (LifeSpan)"
sort SCORE 
xtile SCORE_quart = SCORE , nq(5)

foreach x of numlist 1/5 {
	summary SCORE if SCORE_quart==`x'
}


*************Murrumbidgee**********
use "LifeSpan_Intervention_Site_Boundaries_SA2.dta"
merge 1:1 GEO_CODE using "SEIFA_IRSAD.dta"
keep if _merge==3
drop _merge

keep if SITE_NAME=="Murrumbidgee (LifeSpan)"
sort SCORE 
xtile SCORE_quart = SCORE , nq(5)

foreach x of numlist 1/5 {
	summary SCORE if SCORE_quart==`x'
}

