
#load in libraries
library(tidyverse)
library(janitor)
library(here)

deaths <- read_csv(here("clean_data/mw_deaths_clean.csv"))

#plot graph for deaths by suicide split by gender
deaths %>% 
  filter(issue == "Suicide") %>% 
  group_by(gender, year) %>% 
  summarise(count = sum(number)) %>% 
  ggplot(aes(x = year, y = count, group = gender, colour = gender)) +
  geom_line() +
  geom_point(size=2, shape=21, fill="white") +
  theme(axis.text.x = element_text( angle = 90,  hjust = 1 )) +
  labs(
    y = "Suicide Number",
    x = "Year"
  ) +
  ggtitle("Suicide Rates") +
  theme(plot.title=element_text(hjust = 0.5, family="serif",
                                colour="darkred", size= 18, face = "bold"))


#plot graph for deaths by dementia & alzheimers split by gender
deaths %>% 
  filter(issue == "Dementia_and_Alzheimers") %>% 
  group_by(gender, year) %>% 
  summarise(count = sum(number)) %>% 
  ggplot(aes(x = year, y = count, group = gender, colour = gender)) +
  geom_line() +
  geom_point(size=2, shape=21, fill="white") +
  theme(axis.text.x = element_text( angle = 90,  hjust = 1 )) +
  labs(
    y = "Number of Deaths",
    x = "Year"
  ) +
  ggtitle("Dementia & Alzheimers Rates") +
  theme(plot.title=element_text(hjust = 0.5, family="serif",
                                colour="darkred", size= 18, face = "bold"))




