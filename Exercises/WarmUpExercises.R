#' ---
#' title: "Warm-up Exercises"
#' output:
#'   html_document:
#'     df_print: paged
#' ---
#' 
#' # Course set-up
#' First, let's make sure you have everything you need for the course. Run the following library statements. If something is not installed, install it.
#' 
## ----setup----------------------------------------------------------------------------------------------------------------------
# install.packages("tidyverse")
# remotes::install_github("bschneidr/r-forge-survey-mirror")
# install.packages("srvyr")
# install.packages("here")
# install.packages("palmerpenguins")
# install.packages("remotes")

library(tidyverse) # for tidyverse
library(here) # for file paths
library(palmerpenguins)



#' 
#' # Warm-up exercises for Day 1
#' 
## ----datapeek-------------------------------------------------------------------------------------------------------------------
glimpse(penguins)

#' 
#' How many penguins of each species are there? Hint: use `count`
## ----speciestab-----------------------------------------------------------------------------------------------------------------


#' 
#' How many penguins of each species and sex are there? Hint: use `count`
#' 
## ----speciessextab--------------------------------------------------------------------------------------------------------------


#' 
#' 
#' What is the proportion of each species of penguins? Hint: use `count` then `mutate` 
#' 
## ----speciestabp----------------------------------------------------------------------------------------------------------------


#' 
#' What is the proportion of each sex of penguins within species? Hint: use `count` then `group_by` and `mutate` 
#' 
## ----speciessextabp-------------------------------------------------------------------------------------------------------------


#' 
#' 
#' # Warm-up exercises for Day 2
#' 
#' What is the mean body mass in grams of all penguins? Hint: use `summarize` and remove missing data
#' 
## ----peng_meanmass--------------------------------------------------------------------------------------------------------------


#' 
#' What is the mean length of flipper by species? Hint: use `group_by`
#' 
## ----peng_meanflip_species------------------------------------------------------------------------------------------------------


#' 
#' What is the mean flipper length by species and sex?
#' 
## ----peng_meanflip_speciessex---------------------------------------------------------------------------------------------------


#' 
#' Fit a simple linear regression between body mass and flipper length.
#' 
## ----pengLM---------------------------------------------------------------------------------------------------------------------


#' 
