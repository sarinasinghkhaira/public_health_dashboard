library(tidyverse)
library(here)
library(sf)
library(scales)
library(leaflet)
library(htmltools)
library(janitor)

mental_wb <- read_csv(here::here("clean_data/demographic_mh.csv"))

shs_nopivot <- read_csv(here::here("clean_data/shs_clean_nopivot.csv"))

#Reading in the cleaned data
general_health <- read_csv(here("clean_data/general_health.csv")) %>% 
  drop_na() 




#Reading in longterm conditions dataset
longterm_conditions_all <- read_csv(here("clean_data/longterm_conditions_all.csv"))

#Reading in general health survey dataset
general_health <- read_csv(here("clean_data/general_health.csv"))

general_health %>% 
  mutate(
    limiting_long_term_physical_or_mental_health_condition = if_else(limiting_long_term_physical_or_mental_health_condition == "Limiting condition", "Yes", limiting_long_term_physical_or_mental_health_condition),
    limiting_long_term_physical_or_mental_health_condition = if_else(limiting_long_term_physical_or_mental_health_condition == "No limiting condition", "No", limiting_long_term_physical_or_mental_health_condition)
  ) %>% 
  drop_na()


#read in life expectancy data
life <- read_csv(here("clean_data/le.csv"))
life_da <- read_csv(here("clean_data/le_da.csv"))

#read in mental health data
all_time_mental <-read_csv(here::here("clean_data/all_time_mental.csv"))

#read in temporal mh data
npf_mental_wellbeing <- read_csv(
  here::here("clean_data/npf_mental_health.csv"))

death <- read_csv(here("clean_data/mw_deaths_clean.csv"))

#add labels
all_time_mental <- all_time_mental %>%
  mutate(
    leaflet_lb = paste(
      "<b>",
      la_name,
      "</b>" ,
      br(),
      "SWEMWBS Score: ",
      swem_score,
      br(),
      "Change in average score", 
      br(),
      "from 2014 to 2017: ",
      paste0(ifelse(trend >= 0, "<span style=\"color:green\"> +", "<span style=\"color:red\">"), round(trend, digits = 2), "</span>"),
      br(),
      "SIMD Ranking: ",
      ordinal(la_simd_rank),
      " out of 32",
      br(),
      "Suicide deaths per 100,000: ",
      round(total_suicide_deaths, digits = 2),
      br(),
      "Alcohol delated deaths per 100,000: ",
      round(total_alcohol_dealths, digits = 2)
    )
  )

#read in shapefile
scot_la <- st_read(here::here("clean_data/scot_la.shp"))

scot_la_mh <- scot_la %>%
  left_join(all_time_mental, by = c("area_cod_1" = "feature_code"))

# Set pallete for SWEM score
pal_swem <- colorNumeric(palette = "YlGnBu",
                         domain = scot_la_mh$swem_score)

# Set pallete for suicide  deaths
pal_suicide <- colorNumeric(palette = "plasma",
                            domain = scot_la_mh$total_suicide_deaths)

#Set boundaries of scotland
bbox <- st_bbox(scot_la_mh) %>%
  as.vector()