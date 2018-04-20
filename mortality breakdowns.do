**************************************************************
* File to generate mortality distribution of population, overall
* split by make/female and by urban/rural for use in
* generating LE and HALE at birth distributions by
* wealth quintile
*
* Author: Miqdad Asaria
* Date: Februray 2018
**************************************************************
set more off

use hhid hv024 hv025 sv270* hv005 hv012 hv021 hv023 hv024 hv270 sh71 sh73* sh74* using "/Users/miqdad/Documents/projects/India/data/NFHS/round 4 2015-16/IAHR71DT/IAHR71FL.dta", clear

// generate survey weights and set up for use with svy: command
generate wgt = hv005/1000000

* hv270 = wealth quintiles
* sv270s = state wealth quintile
* sv270u = urban wealth quintile
* sv270r = urban wealth quintile
* hv024 = state (5=BIHAR, 33=UP, 17=KERALA, 31=TAMIL NADU)
* hv025 = urban/rural
* sh73 = sex of dead person
* sh74 = age of dead person

* keep only the deaths
reshape long sh73_ sh74u_ sh74n_, i(hhid) j(death_num)
keep if sh73_ != .
gen age_at_death_years = .
replace age_at_death_years = sh74n_ if sh74u_==3
replace age_at_death_years = sh74n_/12 if sh74u_==2
replace age_at_death_years = sh74n_/365.25 if sh74u_==1

* mean impute missing values
*qui summ age_at_death_years
*scalar ave_age = r(mean)
*replace age_at_death_years = ave_age if sh74u_==8

* convert to age groups as per lifetable
gen age_group = .
label define age_group_lab 1 "<1" 2 "1-4" 3 "5-9" 4 "10-14" 5 "15-19" 6 "20-24" ///
	7 "25-29" 8 "30-34" 9 "35-39" 10 "40-44" 11 "45-49" 12 "50-54" 13 "55-59" ///
	14 "60-64" 15 "65-69" 16 "70-74" 17 "75-79" 18 "80-84" 19 "85+" 20 "missing"
label values age_group age_group_lab
 
* <1
replace age_group = 1 if age_at_death_years<1
* 1-4
replace age_group = 2 if age_at_death_years>=1 & age_at_death_years<5
* 5-9
replace age_group = 3 if age_at_death_years>=5 & age_at_death_years<10
* 10-14
replace age_group = 4 if age_at_death_years>=10 & age_at_death_years<15
* 15-19
replace age_group = 5 if age_at_death_years>=15 & age_at_death_years<20
* 20-24
replace age_group = 6 if age_at_death_years>=20 & age_at_death_years<25
* 25-29
replace age_group = 7 if age_at_death_years>=25 & age_at_death_years<30
* 30-34
replace age_group = 8 if age_at_death_years>=30 & age_at_death_years<35
* 35-39
replace age_group = 9 if age_at_death_years>=35 & age_at_death_years<40
* 40-44
replace age_group = 10 if age_at_death_years>=40 & age_at_death_years<45
* 45-49
replace age_group = 11 if age_at_death_years>=45 & age_at_death_years<50
* 50-54
replace age_group = 12 if age_at_death_years>=50 & age_at_death_years<55
* 55-59
replace age_group = 13 if age_at_death_years>=55 & age_at_death_years<60
* 60-64
replace age_group = 14 if age_at_death_years>=60 & age_at_death_years<65
* 65-69
replace age_group = 15 if age_at_death_years>=65 & age_at_death_years<70
* 70-74
replace age_group = 16 if age_at_death_years>=70 & age_at_death_years<75
* 75-79
replace age_group = 17 if age_at_death_years>=75 & age_at_death_years<80
* 80-84
replace age_group = 18 if age_at_death_years>=80 & age_at_death_years<85
* 85+
replace age_group = 19 if age_at_death_years>=85 & age_at_death_years!=.
* missing
replace age_group = 20 if age_at_death_years==.

**********************
* TOTAL Population
**********************

* calculate total deaths by national wealth quintile
table age_group hv270 [iweight=wgt], row
* male/female split
bysort sh73_: table age_group hv270 [iweight=wgt], row

**********************
* RURAL Population
**********************

* calculate rural deaths by rural wealth quintile
table age_group sv270r [iweight=wgt] if hv025==2, row
* male/female split
bysort sh73_: table age_group sv270r [iweight=wgt] if hv025==2, row

**********************
* URBAN Population
**********************

* calculate urban deaths by urban wealth quintile
table age_group sv270u [iweight=wgt] if hv025==1, row
* male/female split
bysort sh73_: table age_group sv270u [iweight=wgt] if hv025==1, row
