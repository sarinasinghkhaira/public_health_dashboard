library(tidyverse)
library(readxl)
library(janitor)
library(here)

mental_wb_survey <- read_csv(here::here("raw_data/mental_wb_scottish_surveys.csv")) %>% 
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
data_zones <- read_csv(here::here("raw_data/Datazone2011lookup.csv")) %>% 
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

all_time_mental <- mental_survey_la %>%
  filter(date_code == "2014-2017") 

#Join data zone names to mental health data
all_time_mental <- all_time_mental %>%
  left_join(la_data_zones, by = c("feature_code" = "la_code"))

#Export all time data for mental health (average across population for years 2014 - 2017) for map
simd <- read_csv(here::here("clean_data/simd_la_2012_2020.csv")) %>%
  filter(year == "2016") %>%
  select(la_code, la_simd_mean, la_simd_rank)

#read in suicide data
suicide_drug_alcohol <- read_csv(here::here("clean_data/mh_la_5yr_agg.csv"))

#join suicide to mental health data
suicide_drug_alcohol <- suicide_drug_alcohol %>% 
  select(indicator, sex, la_code, measure, year) %>%
  filter(year == 2016) %>%
  pivot_wider(names_from = indicator, 
              values_from = measure) %>% clean_names() %>%
  pivot_wider(names_from = sex,
              values_from = c("alcohol_specific_deaths", "drug_related_deaths", "deaths_from_suicide")) %>%
  mutate(total_suicide_deaths = (deaths_from_suicide_females + deaths_from_suicide_males)/2)

#join mental health data together
all_time_mental <- all_time_mental %>% 
  left_join(simd, by = c("feature_code" = "la_code")) %>% 
  left_join(suicide_drug_alcohol, by = c("feature_code" = "la_code"))

#export to csv
write_csv(all_time_mental, "clean_data/all_time_mental.csv")
