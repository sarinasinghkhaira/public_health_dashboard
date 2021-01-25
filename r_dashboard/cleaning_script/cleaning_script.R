library(tidyverse)
library(janitor)

#SWEMBS values (https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fmental-wellbeing-sscq)
swemwbs <- read_csv("possible_topics/ment_wellbeing.csv") %>% clean_names() 

gen_health <- read_csv("possible_topics/General_Health_Surveys.csv") %>% clean_names()

#SIMD data from 2012,2016,2020
simd2020 <- read_csv("possible_topics/SIMD+2020v2+-+datazone+lookup.xlsx - SIMD 2020v2 DZ lookup data.csv") %>% 
  clean_names() %>% 
  rename(la_code = l_acode) %>% 
  rename(la_name = l_aname)
simd2016 <- read_csv("possible_topics/00534450 - SIMD16 ranks.csv") %>% clean_names()
simd2012 <- read_csv("possible_topics/00410767 - SIMD 2012.csv") %>% clean_names()

mental_health <-read_csv("possible_topics/mntl_hlth_shs_4yr_agg.csv") %>% clean_names()

g_b_space <- read_csv("possible_topics/green_blue_space.csv") %>% clean_names()

shs <- read_csv("possible_topics/scottish_health_survey.csv") %>% clean_names()

lookup <- read_csv("possible_topics/Datazone2011lookup.csv") %>% clean_names()




lookup_la <- lookup %>% # create LA lookup table 
  select(la_code, la_name) %>% 
  distinct()


shs_la <- shs %>% 
  filter(str_detect(feature_code, "^S12")) %>% 
  rename(la_code = feature_code) %>% 
  left_join(lookup_la, by= "la_code") %>% 
  relocate(la_name, .after = la_code) %>% 
  filter(measurement == "Percent") %>% 
  group_by(la_name) %>% 
  pivot_wider(names_from = scottish_health_survey_indicator, values_from = value) %>% 
  select(1:6,sort(names(.)))



g_b_space_la <- g_b_space %>%
  filter(str_detect(feature_code, "^S12")) %>% 
  rename(la_code = feature_code) %>% 
  left_join(lookup_la, by= "la_code") %>% 
  relocate(la_name, .after = la_code) %>% 
  filter(measurement == "Percent") %>% 
  group_by(la_name) %>% 
  pivot_wider(names_from = distance_to_nearest_green_or_blue_space, values_from = value)



mental_health <- mental_health %>% # separate out sex to new column
  mutate(sex=unlist(lapply(strsplit(indicator,", "),function(x) x[2])),
         indicator=gsub(",.*","",indicator)) %>% 
  relocate(sex, .after = indicator)

mh_la <- mental_health %>% # filter only local authority areas and clean up
  filter(grepl('Council area', area_type)) %>% 
  rename(la_code = area_code) %>%
  rename(la_name = area_name) %>% 
  mutate(la_name = str_replace(la_name, "&", "and")) 

mh_la_4yr_agg <- mh_la %>% # filter only 4 yr aggregates
  filter(grepl(".*4-year aggregate.*", period))

mh_la_5yr_agg <-  mh_la %>% # filter only 5 yr aggregates
  filter(grepl(".*5-year aggregates.*", period))

swemwbs_la <- swemwbs %>% # filter to only local authority rows and match s12 code to LA name
  filter(str_detect(feature_code, "^S12")) %>% 
  rename(la_code = feature_code) %>% 
  left_join(lookup_la, by= "la_code") %>% 
  relocate(la_name, .after = la_code)

gen_health_la <- gen_health %>% 
  filter(str_detect(feature_code, "^S12")) %>% 
  rename(la_code = feature_code) %>% 
  left_join(lookup_la, by= "la_code") %>% 
  relocate(la_name, .after = la_code) %>% 
  filter(measurement == "Percent") %>% 
  group_by(la_name) %>% 
  pivot_wider(names_from = self_assessed_general_health, values_from = value)

simd_la_2016 <- simd2016 %>% 
  rename(la_name = council_area) %>%
  mutate(la_name = str_replace(la_name, "Na h-Eileanan an Iar", "Na h-Eileanan Siar")) %>% #update change to LA name
  left_join(lookup_la, by= "la_name") %>% # lookup la_code
  relocate(la_code, .after = intermediate_zone) %>% 
  relocate(la_name, .after = la_code) 

simd_la_2012 <- simd2012 %>% 
  rename(la_name = local_authority_name) %>%
  mutate(la_name = str_replace(la_name, "Eilean Siar", "Na h-Eileanan Siar")) %>% #update changes to LA names
  mutate(la_name = str_replace(la_name, "&", "and")) %>%
  mutate(la_name = str_replace(la_name, "Edinburgh, City of", "City of Edinburgh")) %>%
  left_join(lookup_la, by= "la_name") %>% # lookup la_code
  relocate(la_code, .after = la_name)

simd_la <- simd2020 %>% 
  mutate(year = "2020") %>% 
  group_by(la_code) %>% 
  mutate(la_simd_mean = mean(simd2020v2_rank)) %>%
  mutate(la_simd_income_mean = mean(simd2020v2_income_domain_rank)) %>% 
  mutate(la_simd_employ_mean = mean(simd2020_employment_domain_rank)) %>% 
  mutate(la_simd_edu_mean = mean(simd2020_education_domain_rank)) %>% 
  mutate(la_simd_health_mean = mean(simd2020_health_domain_rank)) %>% 
  mutate(la_simd_access_mean = mean(simd2020_access_domain_rank)) %>% 
  mutate(la_simd_crime_mean = mean(simd2020_crime_domain_rank)) %>%
  mutate(la_simd_housing_mean = mean(simd2020_housing_domain_rank)) %>% 
  mutate(la_pop_total = sum(population)) %>% 
  mutate(la_workpop_total = sum(working_age_population)) %>% 
  select(year, la_code, la_name, la_simd_mean, la_simd_income_mean, la_simd_employ_mean, la_simd_edu_mean, la_simd_health_mean, la_simd_access_mean, la_simd_crime_mean, la_simd_housing_mean, la_pop_total, la_workpop_total) %>% 
  distinct() %>% 
  ungroup() %>% 
  mutate(la_simd_rank = rank(la_simd_mean)) %>% 
  relocate(la_simd_rank, .after = la_simd_mean) %>% 
  mutate(la_simd_income_rank = rank(la_simd_income_mean)) %>% 
  relocate(la_simd_income_rank, .after = la_simd_income_mean) %>% 
  mutate(la_simd_employ_rank = rank(la_simd_employ_mean)) %>% 
  relocate(la_simd_employ_rank, .after = la_simd_employ_mean) %>% 
  mutate(la_simd_edu_rank = rank(la_simd_edu_mean)) %>% 
  relocate(la_simd_edu_rank, .after = la_simd_edu_mean) %>% 
  mutate(la_simd_health_rank = rank(la_simd_health_mean)) %>% 
  relocate(la_simd_health_rank, .after = la_simd_health_mean) %>% 
  mutate(la_simd_access_rank = rank(la_simd_access_mean)) %>% 
  relocate(la_simd_access_rank, .after = la_simd_access_mean) %>% 
  mutate(la_simd_crime_rank = rank(la_simd_crime_mean)) %>% 
  relocate(la_simd_crime_rank, .after = la_simd_crime_mean) %>%  
  mutate(la_simd_housing_rank = rank(la_simd_housing_mean)) %>% 
  relocate(la_simd_housing_rank, .after = la_simd_housing_mean) %>% 
  mutate(la_pop_total_rank = rank(desc(la_pop_total))) %>% 
  relocate(la_pop_total_rank, .after = la_pop_total) %>% 
  mutate(la_workpop_total_rank = rank(desc(la_workpop_total))) %>% 
  relocate(la_workpop_total_rank, .after = la_workpop_total) 

simd_la_2016 <- simd_la_2016  %>% 
  mutate(year = "2016") %>%
  group_by(la_code) %>% 
  mutate(la_simd_mean = mean(overall_simd16_rank)) %>%
  mutate(la_simd_income_mean = mean(income_domain_2016_rank)) %>% 
  mutate(la_simd_employ_mean = mean(employment_domain_2016_rank)) %>% 
  mutate(la_simd_edu_mean = mean(education_domain_2016_rank)) %>% 
  mutate(la_simd_health_mean = mean(health_domain_2016_rank)) %>% 
  mutate(la_simd_access_mean = mean(access_domain_2016_rank)) %>% 
  mutate(la_simd_crime_mean = mean(crime_domain_2016_rank)) %>%
  mutate(la_simd_housing_mean = mean(housing_domain_2016_rank)) %>% 
  mutate(la_pop_total = sum(total_population)) %>% 
  mutate(la_workpop_total = sum(working_age_population_revised)) %>% 
  select(year, la_code, la_name, la_simd_mean, la_simd_income_mean, la_simd_employ_mean, la_simd_edu_mean, la_simd_health_mean, la_simd_access_mean, la_simd_crime_mean, la_simd_housing_mean, la_pop_total, la_workpop_total) %>% 
  distinct() %>% 
  ungroup() %>% 
  mutate(la_simd_rank = rank(la_simd_mean)) %>% 
  relocate(la_simd_rank, .after = la_simd_mean) %>% 
  mutate(la_simd_income_rank = rank(la_simd_income_mean)) %>% 
  relocate(la_simd_income_rank, .after = la_simd_income_mean) %>% 
  mutate(la_simd_employ_rank = rank(la_simd_employ_mean)) %>% 
  relocate(la_simd_employ_rank, .after = la_simd_employ_mean) %>% 
  mutate(la_simd_edu_rank = rank(la_simd_edu_mean)) %>% 
  relocate(la_simd_edu_rank, .after = la_simd_edu_mean) %>% 
  mutate(la_simd_health_rank = rank(la_simd_health_mean)) %>% 
  relocate(la_simd_health_rank, .after = la_simd_health_mean) %>% 
  mutate(la_simd_access_rank = rank(la_simd_access_mean)) %>% 
  relocate(la_simd_access_rank, .after = la_simd_access_mean) %>% 
  mutate(la_simd_crime_rank = rank(la_simd_crime_mean)) %>% 
  relocate(la_simd_crime_rank, .after = la_simd_crime_mean) %>%  
  mutate(la_simd_housing_rank = rank(la_simd_housing_mean)) %>% 
  relocate(la_simd_housing_rank, .after = la_simd_housing_mean) %>% 
  mutate(la_pop_total_rank = rank(desc(la_pop_total))) %>% 
  relocate(la_pop_total_rank, .after = la_pop_total) %>% 
  mutate(la_workpop_total_rank = rank(desc(la_workpop_total))) %>% 
  relocate(la_workpop_total_rank, .after = la_workpop_total)

simd_la_2012 <- simd_la_2012  %>% 
  mutate(year = "2012") %>%
  group_by(la_code) %>% 
  mutate(la_simd_mean = mean(overall_simd_2012_rank)) %>%
  mutate(la_simd_income_mean = mean(income_domain_2012_rank)) %>% 
  mutate(la_simd_employ_mean = mean(employment_domain_2012_rank)) %>% 
  mutate(la_simd_edu_mean = mean(education_skills_and_training_domain_2012_rank)) %>% 
  mutate(la_simd_health_mean = mean(health_domain_2012_rank)) %>% 
  mutate(la_simd_access_mean = mean(geographic_access_domain_2012_rank)) %>% 
  mutate(la_simd_crime_mean = mean(simd_crime_2012_rank)) %>%
  mutate(la_simd_housing_mean = mean(housing_domain_rank_2004_2006_2009_2012)) %>% 
  mutate(la_pop_total = sum(total_population_sape_2010)) %>% 
  mutate(la_workpop_total = sum(best_fit_working_age_population_men_16_64_women_16_60_sape_2010)) %>% 
  select(year, la_code, la_name, la_simd_mean, la_simd_income_mean, la_simd_employ_mean, la_simd_edu_mean, la_simd_health_mean, la_simd_access_mean, la_simd_crime_mean, la_simd_housing_mean, la_pop_total, la_workpop_total) %>% 
  distinct() %>% 
  ungroup() %>% 
  mutate(la_simd_rank = rank(la_simd_mean)) %>% 
  relocate(la_simd_rank, .after = la_simd_mean) %>% 
  mutate(la_simd_income_rank = rank(la_simd_income_mean)) %>% 
  relocate(la_simd_income_rank, .after = la_simd_income_mean) %>% 
  mutate(la_simd_employ_rank = rank(la_simd_employ_mean)) %>% 
  relocate(la_simd_employ_rank, .after = la_simd_employ_mean) %>% 
  mutate(la_simd_edu_rank = rank(la_simd_edu_mean)) %>% 
  relocate(la_simd_edu_rank, .after = la_simd_edu_mean) %>% 
  mutate(la_simd_health_rank = rank(la_simd_health_mean)) %>% 
  relocate(la_simd_health_rank, .after = la_simd_health_mean) %>% 
  mutate(la_simd_access_rank = rank(la_simd_access_mean)) %>% 
  relocate(la_simd_access_rank, .after = la_simd_access_mean) %>% 
  mutate(la_simd_crime_rank = rank(la_simd_crime_mean)) %>% 
  relocate(la_simd_crime_rank, .after = la_simd_crime_mean) %>%  
  mutate(la_simd_housing_rank = rank(la_simd_housing_mean)) %>% 
  relocate(la_simd_housing_rank, .after = la_simd_housing_mean) %>% 
  mutate(la_pop_total_rank = rank(desc(la_pop_total))) %>% 
  relocate(la_pop_total_rank, .after = la_pop_total) %>% 
  mutate(la_workpop_total_rank = rank(desc(la_workpop_total))) %>% 
  relocate(la_workpop_total_rank, .after = la_workpop_total)

simd_la_2012_2020 <- bind_rows(simd_la, simd_la_2016, simd_la_2012)