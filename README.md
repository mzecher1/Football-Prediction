I used a regression analysis to predict NFL games against the spread. I used data from weeks 1-8 from 2019 to build my analysis and inputs. I then merged in data from weeks 9-17 to test the model, which resulted in a winning record of 65-52 (56.7%). 

The log file outlines the process of building and testing the model. It uses data to ascertain the amount that different statistical outputs lead to a scoring differential in NFL games. Using this and team’s performance from this time we can then assign each time a presumed score differential value. 

With these values one can then predict games against the spread. 

All relevant data sets are in the Github repository. These include the full NFL data set (NFL DATA.csv), and the two sets to merge in later (NFLMERGE#1.dta & NFL Merge 3.dta).  NFLMERGE#1 adds back weeks 9-17 after they were dropped and NFL Merge 3 has the team rankings based off the original analysis. 


