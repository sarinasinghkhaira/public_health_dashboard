library(tidyverse)
library(here)

mental_wb <- read_csv(here::here("clean_data/demographic_mh.csv"))

shs_nopivot <- read_csv(here::here("clean_data/shs_clean_nopivot.csv"))

#Reading in the cleaned data
general_health <- read_csv(here("clean_data/general_health.csv")) %>% 
  drop_na() 