library(tidyverse)
library(janitor)
library(stringr)

#Cleaning cerebrovascular disease dataset
cerebrovascular_disease_admissions_raw <- read_csv("raw_data/cerebrovascular_disease_hospital_admissions.csv") %>%  
  clean_names() %>% 
  #renaming the column "http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area" to simply "reference code"
  rename(reference_code = http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area) %>% 
  #removing the website address from the beginning of each reference code in the reference code column
  mutate(
    reference_code =
      str_remove_all(
        reference_code, "http://statistics.gov.scot/id/statistical-geography/")
  ) 

#Removing "x" from the start of each each from 2002 to 2012
names(cerebrovascular_disease_admissions_raw) <- str_remove_all(colnames(cerebrovascular_disease_admissions_raw), "x")

#Using pivot longer to create a column "year" for all columns 2002 - 2012 and another column count for values to come under
cerebrovascular_disease_admissions_clean <- cerebrovascular_disease_admissions_raw %>% 
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "year", 
    values_to = "admissions_count")

#Cleaning coronary heart disease dataset
coronary_heart_disease_admissions_raw <- read_csv("raw_data/coronary_heart_disease_admissions.csv") %>%  
  clean_names() %>% 
  #renaming the column "http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area" to simply "reference code"
  rename(reference_code = http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area) %>% 
  #removing the website address from the beginning of each reference code in the reference code column
  mutate(
    reference_code =
      str_remove_all(
        reference_code, "http://statistics.gov.scot/id/statistical-geography/")
  ) 

#Removing "x" from the start of each each from 2002 to 2012
names(coronary_heart_disease_admissions_raw) <- str_remove_all(colnames(coronary_heart_disease_admissions_raw), "x")

#Using pivot longer to create a column "year" for all columns 2002 - 2012 and another column count for values to come under
coronary_heart_disease_admissions_clean <- coronary_heart_disease_admissions_raw %>% 
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "year", 
    values_to = "admissions_count")

#Cleaning disease of the digestive system dataset
disease_digestive_system_admissions_raw <- read_csv("raw_data/disease_digestive_system_admissions.csv") %>%  
  clean_names() %>% 
  #renaming the column "http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area" to simply "reference code"
  rename(reference_code = http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area) %>% 
  #removing the website address from the beginning of each reference code in the reference code column
  mutate(
    reference_code =
      str_remove_all(
        reference_code, "http://statistics.gov.scot/id/statistical-geography/")
  ) 

#Removing "x" from the start of each each from 2002 to 2012
names(disease_digestive_system_admissions_raw) <- str_remove_all(colnames(disease_digestive_system_admissions_raw), "x")

#Using pivot longer to create a column "year" for all columns 2002 - 2012 and another column count for values to come under
disease_digestive_system_admissions_clean <- disease_digestive_system_admissions_raw %>% 
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "year", 
    values_to = "admissions_count")

#Cleaning respiratory disease dataset
respiratory_disease_hospital_admissions_raw <- read_csv("raw_data/respiratory_disease_hospital_admissions.csv") %>%  
  clean_names() %>% 
  #renaming the column "http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area" to simply "reference code"
  rename(reference_code = http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area) %>% 
  #removing the website address from the beginning of each reference code in the reference code column
  mutate(
    reference_code =
      str_remove_all(
        reference_code, "http://statistics.gov.scot/id/statistical-geography/")
  ) 

#Removing "x" from the start of each each from 2002 to 2012
names(respiratory_disease_hospital_admissions_raw) <- str_remove_all(colnames(respiratory_disease_hospital_admissions_raw), "x")

#Using pivot longer to create a column "year" for all columns 2002 - 2012 and another column count for values to come under
respiratory_disease_hospital_admissions_clean <- respiratory_disease_hospital_admissions_raw %>% 
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "year", 
    values_to = "admissions_count")

#Writing cleaned datasets to csv files
write_csv(cerebrovascular_disease_admissions_clean, "clean_data/cerebrovascular_disease_admissions.csv")

write_csv(coronary_heart_disease_admissions_clean, "clean_data/coronary_heart_disease_admissions.csv")

write_csv(disease_digestive_system_admissions_clean, "clean_data/disease_digestive_system_admissions.csv")

write_csv(respiratory_disease_hospital_admissions_clean, "clean_data/respiratory_disease_hospital_admissions.csv")