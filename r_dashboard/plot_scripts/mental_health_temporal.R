library(janitor)
library(tidyverse)
library(here)


npf_database <- read_excel(here::here("raw_data/NPF Database  - 19.01.2021.xlsx")) %>% 
  clean_names()

npf_mental_wellbeing <- npf_database %>% filter(indicator == "Mental wellbeing") %>%
  select(-source, outcome) %>%
  mutate(year = as.numeric(year),
         figure = as.numeric(figure))

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
       subtitle = "Average WEMWBS Score 2006 - 2019")