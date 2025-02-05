#' ---
#' title: "Continous Data Analysis Exercises"
#' output:
#'   html_document:
#'     df_print: paged
#' ---
#' 
#' # Set-up
## ------------------------------------------------------------------------
library(tidyverse) # for tidyverse
library(here) # for file paths
library(survey) # for survey analysis
library(srvyr) # for tidy survey analysis

recs <- read_rds(here("Data", "recs.rds"))

recs_des <- recs %>%
   as_survey_rep(weights=NWEIGHT,
                 repweights=starts_with("BRRWT"),
                 type="Fay",
                 rho=0.5,
                 mse=TRUE)

#' 
#' # Part 1
#' 
#' 1. Find the average square footage of housing units (TOTSQFT_EN) with a 90% confidence interval.
#' 
## ------------------------------------------------------------------------


#' 
#' 2. Estimate the ratio of cooled square footage to total square footage (TOTCSQFT) to the total square footage of housing units (TOTSQFT_EN) with its standard error.
#' 
## ------------------------------------------------------------------------


#' 
#' 3. Estimate the median temperature housing units are set to during the night in the winter (WinterTempNight) using the `survey_median` function.
#' 
## ------------------------------------------------------------------------


#' 
#' 4. Estimate the median temperature housing units are set to during the night in the winter (WinterTempNight) using the `survey_quantile` function.
#' 
## ------------------------------------------------------------------------


#' 
#' # Part 2
#' 
#' 1. Estimate the total average energy cost (TOTALDOL) by region, division, and urbanicity.
#' 
## ------------------------------------------------------------------------


#' 
#' 2. What is the median electric cost (DOLLAREL) for housing units in the South Region? What is the 95% confidence interval?
#' 
## ------------------------------------------------------------------------


#' 
#' 3. Test whether daytime winter and daytime summer temperatures of homes are set the same.
#' 
## ------------------------------------------------------------------------


#' 
#' 4. Test whether average electric bill (DOLLAREL) varies by region (Region).
#' 
## ------------------------------------------------------------------------


#' 
#' 5. Fit a regression between the cooled square footage of a housing unit (TOTCSQFT) and the total amount spent on energy (TOTALDOL).
#' 
## ------------------------------------------------------------------------


#' 
