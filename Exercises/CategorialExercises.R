#' ---
#' title: "Categorical Data Analysis Exercise Solutions"
#' output:
#'   html_document:
#'     df_print: paged
#' ---
#' 
#' # Set-up
## ----setup---------------------------------------------------------------
library(tidyverse) # for tidyverse
library(here) # for file paths
library(survey) # for survey analysis
library(srvyr) # for tidy survey analysis

anes <- read_rds(here("Data", "anes_2020.rds")) %>%
   mutate(Weight=Weight/sum(Weight)*231592693) 
# adjust weight to sum to citizen pop, 18+ in Nov 2020 per ANES methodology documentation
anes_des <- anes %>%
   as_survey_design(weights = Weight,
                    strata = Stratum,
                    ids = VarUnit,
                    nest = TRUE)

#' 
#' # Part 1
#' 
#' 1. How many females have a graduate degree? Hint: the variables `Gender` and `Education` will be useful.
#' 
## ----ex1_1---------------------------------------------------------------



#' 
#' 
#' 2. What percentage of people identify as "Strong democrat"? Hint: The variable `PartyID` indicates what party people identify with.
#' 
## ----ex1_2---------------------------------------------------------------


#' 
#' 
#' 
#' 3. What percentage of people who voted in the 2020 election identify as "Strong republican"? Hint: The variable `VotedPres2020` indicates whether someone voted in 2020.
#' 
## ----ex1_3---------------------------------------------------------------


#' 
#' 4. What percentage of people voted in both the 2016 election and in the 2020 election?  Include the logit confidence interval. Hint: The variable `VotedPres2016` indicates whether someone voted in 2016.
#' 
## ----ex1_4---------------------------------------------------------------


#' 
#' 5. What is the design effect for the proportion of people who voted early? Hint: The variable `EarlyVote2020` indicates whether someone voted early in 2020.
#' 
## ----ex1_5---------------------------------------------------------------


#' 
#' # Part 2
#' 
#' 1. Is there a relationship between PartyID and whether people voted early?
#' 
## ----ex2_1---------------------------------------------------------------


#' 
#' 
#' 2. Is there a relationship between PartyID and trust in the government? Hints: `TrustGovernment` indicates how strongly people trust the government. Use Wald as the `statistic` option.
#' 
## ----ex2_2---------------------------------------------------------------


#' 
#' 
#' # Bonus
#' 
#' 1. What percentage of people lean republican? These are individuals that are strong republicans, not very strong republicans and are independent-republicans. Include an appropriate confidence interval. Hint: to get the correct confidence interval, create a new variable BEFORE calculating the estimate.
#' 
## ----exb_1---------------------------------------------------------------


#' 
#' 2. Were people who lean democrat more likely to vote early in the 2020 election? Hint: use a logistic model and 3-level party variable to use in the model.
#' 
## ----exb_2---------------------------------------------------------------


