library(tidyverse)
library(janitor)
library(stringr)

# Link to the raw data:-
# https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fgeneral-health-sscq

data_zone_lookup <- read_csv(here("raw_data/Datazone2011lookup.csv.xls"))

#Cleaning general health dataset
general_health_raw <- read_csv("raw_data/general_health_survey.csv") %>%  
  clean_names()

general_health_raw

#Checking for missing values across all columns
general_health_raw_missing <- general_health_raw %>% 
  summarise(across(.fns = ~sum(is.na(.x))))
#16023 missing date codes

#Show which areas the missing values are coming from
general_health_raw_missing <- general_health_raw %>% 
  filter(is.na(date_code))

general_health_clean <- general_health_raw

#Writing cleaned datasets to csv files
write_csv(general_health_clean, "clean_data/general_health.csv")
