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
#Option 1:
femgd <- anes_des %>%
   filter(Gender=="Female", Education=="Graduate") %>%
   survey_count(name="n")
#Option 2:
femgd <- anes_des %>%
   filter(Gender=="Female", Education=="Graduate") %>%
   summarize(
      N=survey_total(),  .groups="drop"
   )


#' 
#' There are `r formatC(pull(femgd, N), format="d", big.mark=",")` females with a graduate degree.
#' 
#' 
#' 2. What percentage of people identify as "Strong democrat"? Hint: The variable `PartyID` indicates what party people identify with.
#' 
## ----ex1_2---------------------------------------------------------------
(psd <- anes_des %>%
   group_by(PartyID) %>% 
   summarize(
      p=survey_mean()
   ) %>%
   filter(PartyID=="Strong democrat"))

#' 
#' `r str_c(round(pull(psd, p)*100, 1), "%")` of people identify as a strong democrat.
#' 
#' 
#' 3. What percentage of people who voted in the 2020 election identify as "Strong republican"? Hint: The variable `VotedPres2020` indicates whether someone voted in 2020.
#' 
## ----ex1_3---------------------------------------------------------------
(psr <- anes_des %>%
   filter(VotedPres2020=="Yes") %>% 
   group_by(PartyID) %>% 
   summarize(
      p=survey_mean()
   ) %>%
   filter(PartyID=="Strong republican"))

#' 
#' `r str_c(round(pull(psr, p)*100, 1), "%")` of people identify as a strong republican among those who voted in 2020.
#' 
#' 4. What percentage of people voted in both the 2016 election and in the 2020 election?  Include the logit confidence interval. Hint: The variable `VotedPres2016` indicates whether someone voted in 2016.
#' 
## ----ex1_4---------------------------------------------------------------
(pvb <- anes_des %>%
   filter(!is.na(VotedPres2016), !is.na(VotedPres2020)) %>%
   group_by(interact(VotedPres2016, VotedPres2020)) %>% 
   summarize(
      p=survey_prop(var="ci", method="logit"),
   ) %>%
   filter(VotedPres2016=="Yes", VotedPres2020=="Yes"))

#' 
#' `r str_c(round(pull(pvb, p)*100, 1), "%")` (`r round(pull(pvb, p_low)*100, 1)`-`r str_c(round(pull(pvb, p_upp)*100, 1), "%")`) voted in both the 2016 and 2020 elections. 
#' 
#' 
#' 
#' 5. What is the design effect for the proportion of people who voted early? Hint: The variable `EarlyVote2020` indicates whether someone voted early in 2020.
#' 
## ----ex1_5---------------------------------------------------------------
(pdeff <- anes_des %>%
   filter(!is.na(EarlyVote2020)) %>%
   group_by(EarlyVote2020) %>%
   summarize(
      p=survey_mean(deff=TRUE)
   ) %>%
   filter(EarlyVote2020=="Yes"))

#' 
#' The design effect is `r round(pull(pdeff, p_deff), 2)`.
#' 
#' # Part 2
#' 
#' 1. Is there a relationship between PartyID and whether people voted early?
#' 
## ----ex2_1---------------------------------------------------------------
anes_des %>%
   filter(!is.na(PartyID), !is.na(EarlyVote2020)) %>%
   group_by(PartyID, EarlyVote2020) %>%
   summarise(
      p=survey_mean(),
      .groups="drop"
   ) %>%
   filter(EarlyVote2020=="Yes")

(pid_vote <- anes_des %>%
   svychisq(design=.,
            formula=~PartyID +EarlyVote2020))

#' 
#' There is strong association with when people voted and their party, p-value=`r pluck(pid_vote, "p.value") %>% round(5)`
#' 
#' 2. Is there a relationship between PartyID and trust in the government? Hints: `TrustGovernment` indicates how strongly people trust the government. Use Wald as the `statistic` option.
#' 
## ----ex2_2---------------------------------------------------------------
anes_des %>%
   filter(!is.na(PartyID), !is.na(TrustGovernment)) %>%
   group_by(PartyID, TrustGovernment) %>%
   summarise(
      p=survey_mean(),
      .groups="drop"
   ) %>%
   pivot_wider(id_cols=PartyID, names_from = "TrustGovernment", values_from="p")

(pid_trust <- anes_des %>%
   svychisq(design=.,
            formula=~PartyID+TrustGovernment,
            statistic="Wald"))

#' 
#' There is strong association with how much people trust government and their party, p-value=`r pluck(pid_trust, "p.value") %>% round(5)`
#' 
#' # Bonus
#' 
#' 1. What percentage of people lean republican? These are individuals that are strong republicans, not very strong republicans and are independent-republicans. Include an appropriate confidence interval. Hint: to get the correct confidence interval, create a new variable BEFORE calculating the estimate.
#' 
## ----exb_1---------------------------------------------------------------

#Solution 1: Using forcats package
anes_des %>%
   filter(!is.na(PartyID)) %>%
   mutate(PartyID3=fct_collapse(PartyID,
                                LeanDem=c("Strong democrat",
                                          "Not very strong democrat",
                                          "Independent-democrat"),
                                LeanRep=c("Strong republican",
                                          "Not very strong republican",
                                          "Independent-republican"),
                                other_level="Other")) %>% 
   group_by(PartyID3) %>% 
   summarize(p=survey_prop(vartype="ci", proportion = TRUE))

#Solution 2: Using case_when
anes_des %>%
   filter(!is.na(PartyID)) %>%
   mutate(PartyID3=case_when(PartyID %in% c("Strong democrat",
                                            "Not very strong democrat",
                                            "Independent-democrat")~"LeanDem",
                             PartyID %in% c("Strong republican",
                                            "Not very strong republican",
                                            "Independent-republican")~"LeanRep",
                             TRUE~"Other")) %>% 
   group_by(PartyID3) %>% 
   summarize(p=survey_prop(vartype="ci", proportion = TRUE))


#' 
#' 2. Were people who lean democrat more likely to vote early in the 2020 election? Hint: use a logistic model and 3-level party variable to use in the model.
#' 
## ----exb_2---------------------------------------------------------------
anes_des %>%
   mutate(PartyID3=fct_collapse(PartyID,
                                LeanDem=c("Strong democrat",
                                          "Not very strong democrat",
                                          "Independent-democrat"),
                                LeanRep=c("Strong republican",
                                          "Not very strong republican",
                                          "Independent-republican"),
                                other_level="Other")) %>%
   filter(!is.na(PartyID3), !is.na(EarlyVote2020)) %>%
   group_by(PartyID3, EarlyVote2020) %>%
   summarise(
      p=survey_prop(proportion = TRUE)
   ) %>% filter(EarlyVote2020=="Yes")

earlyv_glm<- anes_des %>%
   mutate(PartyID3=fct_collapse(PartyID,
                                LeanDem=c("Strong democrat",
                                          "Not very strong democrat",
                                          "Independent-democrat"),
                                LeanRep=c("Strong republican",
                                          "Not very strong republican",
                                          "Independent-republican"),
                                other_level="Other")) %>% 
   svyglm(design=.,
          formula=(EarlyVote2020=="Yes")~PartyID3,
          family=quasibinomial(),
          na.action=na.omit)

summary(earlyv_glm)

#' 
#' Yes, there is evidence that those leaning democrat were more likely to vote early. They are the reference level in the model and the other coeffecients are negative and significant.
#' 
#' # Session information
#' 
## ----si------------------------------------------------------------------
devtools::session_info(pkgs="attached")

#' 
