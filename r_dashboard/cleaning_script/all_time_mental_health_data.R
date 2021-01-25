library(tidyverse)
library(readxl)
library(janitor)

mental_wb_survey <- read_csv("raw_data/mental_wb_scottish_surveys.csv") %>% 
  clean_names()

#add a column which classifies feature code to what level it is
mental_wb_survey <- mental_wb_survey %>% 
  mutate(
    feature_code_start = str_extract(feature_code, "[S][0-9][0-9]"),
    feature_code_start = recode(feature_code_start, 
                                "S14" = "ukpc_code",
                                "S12" = "la_code",
                                "S08" = "hb_code",
                                "S13" = "mm_ward_code",
                                "S92" = "scotland",
                                "S16" = "spc_code"
    ))

#read in data zones to attach feature code names to feature codes 
data_zones <- read_csv("data/Datazone2011lookup.csv") %>% 
  clean_names() %>% 
  #remove first 4 columns as data zones are too granular for mental heath data
  select(-c(1:4)) %>%
  unique()

#Extract Local Authority names and codes
la_data_zones <- data_zones %>% 
  select(la_code, la_name) %>%
  unique()

#Filter data to select local authority level and select the mean as the measurement
mental_survey_la <-  mental_wb_survey %>%
  filter(feature_code_start == "la_code" & measurement == "Mean") %>%
  rename(swem_score = value) %>%
  select(-feature_code_start, -measurement, -units)

#Join data zone names to mental health data
mental_survey_la <- mental_survey_la %>%
  left_join(la_data_zones, by = c("feature_code" = "la_code"))

#Export all time data for mental health (average across population for years 2014 - 2017) for map
all_time_mental <- mental_survey_la %>%
  filter(date_code == "2014-2017") %>%
  write.csv("clean_data/all_time_mental.csv")