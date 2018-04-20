**************************************************************
* File to generate age distribution of population, overall
* split by make/female and by urban/rural for use in
* generating LE and HALE at birth distributions by
* wealth quintile
*
* Author: Miqdad Asaria
* Date: Februray 2018
**************************************************************

use hhid hv024 hv025 sv270* hv005 hv012 hv021 hv023 hv024 hv104_* hv105_* hv270 using "/Users/miqdad/Documents/projects/India/data/NFHS/round 4 2015-16/IAHR71DT/IAHR71FL.dta", clear

keep if hv024 == 5 | hv024 == 33

// generate survey weights and set up for use with svy: command
generate wgt = hv005/1000000

* hv270 = wealth quintiles
* sv270s = state wealth quintile
* sv270u = urban wealth quintile
* sv270r = urban wealth quintile
* hv024 = state (5=BIHAR, 33=UP, 17=KERALA, 31=TAMIL NADU)
* hv025 = urban/rural
* hv104 = sex of household member
* hv105 = age of household member

* get household members age distribution
reshape long hv104_ hv105_, i(hhid) j(hh_member) string
keep if hv104_ != .

gen age_group = .
label define age_group_lab 1 "<1" 2 "1-4" 3 "5-9" 4 "10-14" 5 "15-19" 6 "20-24" ///
	7 "25-29" 8 "30-34" 9 "35-39" 10 "40-44" 11 "45-49" 12 "50-54" 13 "55-59" ///
	14 "60-64" 15 "65-69" 16 "70-74" 17 "75-79" 18 "80-84" 19 "85+"
label values age_group age_group_lab
 
* <1
replace age_group = 1 if hv105_<1
* 1-4
replace age_group = 2 if hv105_>=1 & hv105_<5
* 5-9
replace age_group = 3 if hv105_>=5 & hv105_<10
* 10-14
replace age_group = 4 if hv105_>=10 & hv105_<15
* 15-19
replace age_group = 5 if hv105_>=15 & hv105_<20
* 20-24
replace age_group = 6 if hv105_>=20 & hv105_<25
* 25-29
replace age_group = 7 if hv105_>=25 & hv105_<30
* 30-34
replace age_group = 8 if hv105_>=30 & hv105_<35
* 35-39
replace age_group = 9 if hv105_>=35 & hv105_<40
* 40-44
replace age_group = 10 if hv105_>=40 & hv105_<45
* 45-49
replace age_group = 11 if hv105_>=45 & hv105_<50
* 50-54
replace age_group = 12 if hv105_>=50 & hv105_<55
* 55-59
replace age_group = 13 if hv105_>=55 & hv105_<60
* 60-64
replace age_group = 14 if hv105_>=60 & hv105_<65
* 65-69
replace age_group = 15 if hv105_>=65 & hv105_<70
* 70-74
replace age_group = 16 if hv105_>=70 & hv105_<75
* 75-79
replace age_group = 17 if hv105_>=75 & hv105_<80
* 80-84
replace age_group = 18 if hv105_>=80 & hv105_<85
* 85+
replace age_group = 19 if hv105_>=85


**********************
* TOTAL Population
**********************

* calculate total population by national wealth quintile
table age_group hv270 [iweight=wgt], row
* male/female split
bysort hv104_: table age_group hv270 [iweight=wgt], row

**********************
* RURAL Population
**********************

* calculate rural population by rural wealth quintile
table age_group sv270r [iweight=wgt] if hv025==2, row
* male/female split
bysort hv104_: table age_group sv270r [iweight=wgt] if hv025==2, row

**********************
* URBAN Population
**********************

* calculate urban population by urban wealth quintile
table age_group sv270u [iweight=wgt] if hv025==1, row
* male/female split
bysort hv104_: table age_group sv270u [iweight=wgt] if hv025==1, row
