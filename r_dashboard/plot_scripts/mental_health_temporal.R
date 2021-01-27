library(janitor)
library(tidyverse)
library(here)

npf_mental_wellbeing <- read_csv(
  here::here("clean_data/npf_mental_health.csv"))

npf_mental_wellbeing %>% 
  filter(characteristic == "Total") %>% 
  ggplot() +
  geom_line(aes(x = year, y = figure)) +
  scale_x_continuous(breaks = seq(min(npf_mental_wellbeing$year), 
                                  max(npf_mental_wellbeing$year)),  
                     labels = seq(min(npf_mental_wellbeing$year), 
                                  max(npf_mental_wellbeing$year))) +
  labs(x = "Year",
       y = "Average WEMWBS Score", 
       title = "Average Mental Wellbeing Score in Scotland",
       subtitle = "Average WEMWBS Score 2006 - 2019") +
  theme_minimal()
