*** Importing Data

import excel "/Users/mendelzecher/NFL DATA.xlsx", sheet("Sheet1") firstrow

*** Renaming Variables 

rename E Time

rename F Result

rename H Home_Away

rename K Opp_Points

rename Tm Team_points

rename Yds PassY

rename U Comp_per

rename Z punt_yrds

rename DConv thirdDC

rename DAtt thirdDA

rename AC fourthDC

rename AD fourthDA

rename AN OppCP_per

***Create Dependent Variable- Score Differential  

gen score_diff =Team_points-Opp_Points

reg score_diff PassY RushY Int OPPP_Yds OPPRYds OPPInt

***Alter variables to make them more readable 

gen passeq =PassY/100
 
gen Rush_100 = RushYds/100 

reg score_diff passeq Rush_100 Int OPPP_Yds OPPRYds OPPInt

***Create W/L, H/A & Time of Poss variables 

generate numvar = real(Result)

recode numvar (. = 1)
replace numvar = 0 if Result =="L"

rename numvar W_L

generate H_A = real(Home_Away)

recode H_A (. = 1)

replace H_A = 0 if (Home_Away) =="@"

gen OPPTOP = 60- ToP
gen TOPDIFF = ToP-OPPTOP

***regression

reg score_diff passeq Rush_100 Att Int Sk OPPP_Yds OPPRYds OPPInt OPPSk OPPAtt H_A  TOPDIFF 

***Cut data for test
***regress week 1-8 
regress score_diff passeq Rush_100 Int Sk OPPP_Yds OPPRYds OPPInt OPPSk Pnt H_A if Week <9 

***Drop weeks 9-17 to produce team score differential ratings 

drop if Week > 8

***Creating variables of teams' mean performance by category
 
by Team, sort: egen mean_passo1 = mean(passeq) 
by Team, sort: egen mean_rusho1 = mean(Rush_100) 
by Team, sort: egen mean_TO1 = mean(Int) 
by Team, sort: egen mean_SK1 = mean(Sk) 
by Team, sort: egen mean_PUNT1 = mean(Pnt) 
by Team, sort: egen mean_passD1 = mean(OPPP_Yds) 
by Team, sort: egen mean_rushD1 = mean(OPPRYds) 
by Team, sort: egen mean_TOOPP1= mean(OPPInt) 
by Team, sort: egen mean_OPPSK1= mean(OPPSk) 
by Team, sort: egen mean_OPP_P_ATT1= mean(OPPAtt) 
by Team, sort: egen mean_TOPDIFF1= mean(TOPDIFF) 
by Team, sort: egen mean_PNT= mean(Pnt) 

***Score differential ratings 

gen OUTCOMEVAR = (4.064372 * mean_passo1)+(5.588963*mean_rusho1)+ (-3.962036*mean_TO1) +(-1.000284*mean_SK1)+(-.0413222*mean_passD1)+(-.0609178 *mean_rushD1)+(4.032003 *mean_TOOPP1)+(1.412348*mean_OPPSK1)+(-.5459014*mean_PNT)+(.1789476*mean_TOPDIFF1)


**Drop all but Team and Score differential ratings

keep Team OUTCOMEVAR
quietly by Team: gen dup = cond(_N==1,0,_n)
drop if dup>1
drop dup

****Merge back in data  

merge 1:m Team using  "/Users/mendelzecher/Documents/NFLMERGE#1.dta"


merge m:1 Opp using "/Users/mendelzecher/Documents/NFL Merge 3.dta", gen(merge_4)

 
***Spread Math 

rename K Opp_Points

rename Tm Team_points

gen final_score_diff = Team_points-Opp_Points

* Which team will choose against the spread?

gen pred_point_spread = OUTCOMEVAR-OPPOUTCOMEVAR

gen pred_spread_winner = pred_point_spread+Spread

gen my_pick = 1

replace my_pick = 0 if pred_spread_winner < 1

drop if my_pick ==0

gen correct = Team_points-Opp_Points+Spread 

gen correct_check =1 

replace correct_check = 0 if correct < 0

gen predicted_winner = 1 

replace predicted_winner =0 if pred_point_spread > 0 & final_score_diff < 0 | pred_point_spread < 0 & final_score_diff > 0

***Check W/L record against the spread  

summ predicted_winner

