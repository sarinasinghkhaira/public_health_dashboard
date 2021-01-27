library(tidyverse)
library(janitor)

#Read in mental health survey data
mental_wb <- read_csv("raw_data/mental_wb_scottish_surveys.csv") %>% 
  clean_names() %>%
  rename("limiting_cond" = limiting_long_term_physical_or_mental_health_condition)

#Read in data zone look up
data_zones <- read_csv(here::here("raw_data/Datazone2011lookup.csv")) %>% 
  clean_names() %>% 
  select(la_code, la_name) %>%
  unique()

#Create a row for Scotland feature code
scotland <- c("S92000003", "Scotland")  
names(scotland) <- c("la_code", "la_name")
s
#Add scotland to other feature code
data_zones <- bind_rows(data_zones, scotland)


mental_wb <- mental_wb %>%
  #Select local authority and Scotland feature codes 
  filter(str_detect(feature_code, "^S12|^S92")) %>%
  #Join to add on names
  left_join(data_zones, by = c("feature_code" = "la_code"))  %>% 
  select(-units) %>%
  #Pivot confidence intervals
  mutate(measurement = recode(measurement, 
                              "Lower 95% Confidence Limit, Mean" = "lower_ci",
                              "Upper 95% Confidence Limit, Mean" = "upper_ci",
                              "Mean" = "mean")) %>%
  pivot_wider(names_from = "measurement",
              values_from = "value") 


write_csv(mental_wb, "clean_data/demographic_mh.csv")