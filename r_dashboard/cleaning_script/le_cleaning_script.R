
library(tidyverse)
library(janitor)

#read in the appropriate files and tidy columns
life <- read_csv("raw_data/life_expectency.csv") %>% clean_names()

devolved_admins <- read_csv("raw_data/life-expectancy-17-19-devolved_admins.csv", 
                            skip = 3, comment = "#" ) %>% clean_names()

g7 <- read_csv("raw_data/g7_life_expectancy.csv") %>%  clean_names()


##################################
#Tidy life expectancy data to create appropriate columns
life <- life %>% 
  #remove text from age column
  mutate(age_num = str_remove(age, " years")) %>% 
#extract & seperate the two ages around the hyphen & remove the hyphen
#age is a range except where age is 0 or age is 90
mutate(age_num_first = str_extract(age, "[0-9]+")) %>% 
  mutate(age_num_second = str_extract(age, "-[0-9]+")) %>% 
  mutate(age_num_second = str_remove(age_num_second, "-")) %>% 
  #convert variables to numeric type
  mutate(age_num_second = as.numeric(age_num_second)) %>% 
  mutate(age_num_first = as.numeric(age_num_first)) %>% 
  #convert NAs to 0
  mutate(age_num_second = coalesce(age_num_second, 0)) %>% 
  #if value of 'second num' is zero set it the value of 'first num
  mutate(age_num_second = if_else(age_num_second == 0, 
                                  age_num_first, age_num_second)) %>%
  #find the average of the two values, catering for where age is 90
  mutate(avg_age = if_else(age_num_second != 90, 
                           (age_num_first + age_num_second)/2 , 90)) %>% 
  #set the life expectancy to the average age + expected remaining years
  mutate(life_expectancy = avg_age + value)

#write out to file le.csv
write.csv(life, "clean_data/le.csv")

######################################
#Tidy life expectancy for parts of the UK  to create appropriate columns

#remove Nas

devolved_admins <- devolved_admins %>% 
  drop_na()

#rename column
devolved_admins <- devolved_admins %>% 
  rename(country = x1)

#create column for life expectancy
devolved_admins <- devolved_admins %>% 
  mutate(life_expect = 0)

#select data from '91 onwards
devolved_admins <- devolved_admins %>% 
  select(-x1980_1982:-x1990_1992)

#make data tidy with a year and life expectancy column
devolved_admins <- devolved_admins %>%
  pivot_longer(
    cols = c("x1991_1993", "x1992_1994", "x1993_1995", "x1994_1996",
             "x1995_1997", "x1996_1998", "x1997_1999", "x1998_2000", 
             "x1999_2001", "x2000_2002", "x2001_2003", "x2002_2004", 
             "x2003_2005", "x2004_2006", "x2005_2007", "x2006_2008", 
             "x2007_2009", "x2008_2010", "x2009_2011", "x2010_2012", 
             "x2011_2013", "x2012_2014", "x2013_2015", "x2014_2016", 
             "x2015_2017", "x2016_2018", "x2017_2019"),
    names_to = "year",
    values_to = "life_expect",
    names_repair = "unique")

#remove 'x' in year values
devolved_admins <- devolved_admins %>% 
  mutate(year = str_remove(year, "x"))

devolved_admins <- devolved_admins %>% clean_names()

#write out to file le_da.csv
write.csv(devolved_admins, "clean_data/le_da.csv")

##################################


#Tidy life expectancy data for G7 nations 

g7 <- g7 %>% 
  mutate(
    country = case_when(
      location == "CAN" ~ "Canada",
      location == "FRA" ~ "France",
      location == "DEU" ~ "Germany",
      location == "ITA" ~ "Italy",
      location == "JPN" ~ "Japan",
      location == "GBR" ~ "United Kingdom",
      location == "USA" ~ "Usa"
    )
  )

#write out to file le_g7.csv
write_csv(g7, "clean_data/le_g7.csv")
