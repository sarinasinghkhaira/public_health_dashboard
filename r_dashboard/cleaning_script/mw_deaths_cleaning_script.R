#load in libraries
library(tidyverse)
library(janitor)

# read in data, ignoring the first 4 lines and ignorginrows with a #
deaths <- read_csv("raw_data/suicides_dementia.csv", 
                   skip = 4, comment = "#", skip_empty_rows = T) %>% clean_names()
#remove blank column

view(deaths)
deaths <- deaths %>% 
  select(year, gender, number, issue)


deaths <- deaths %>% 
  mutate(year = str_remove(year, "- new coding rules"))



view(deaths)

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

  