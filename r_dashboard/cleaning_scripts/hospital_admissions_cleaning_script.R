library(tidyverse)
library(janitor)
library(stringr)
library(here)

here::here()

#Cleaning cerebrovascular disease dataset
cerebrovascular_disease_admissions_raw <- read_csv(here("r_dashboard/raw_data/cerebrovascular_disease_hospital_admissions.csv")) %>%  
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
coronary_heart_disease_admissions_raw <- read_csv(here("r_dashboard/raw_data/coronary_heart_disease_admissions.csv")) %>%  
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
disease_digestive_system_admissions_raw <- read_csv(here("r_dashboard/raw_data/disease_digestive_system_admissions.csv")) %>%  
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
respiratory_disease_hospital_admissions_raw <- read_csv(here("r_dashboard/raw_data/respiratory_disease_hospital_admissions.csv")) %>%  
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


#Cleaning cancer dataset
cancer_admissions_raw <- read_csv(here("r_dashboard/raw_data/cancer_admissions.csv"), skip = 8) %>%  
  clean_names() %>% 
  #renaming the column "http_purl_org_linked_data_sdmx_2009_dimension_number_ref_area" to simply "reference code"
  rename(reference_code = x1) %>% 
  rename(reference_area = x2)

cancer_admissions_raw <- cancer_admissions_raw %>% 
  #removing the website address from the beginning of each reference code in the reference code column
  mutate(
    reference_code =
      str_remove_all(
        reference_code, "http://statistics.gov.scot/id/statistical-geography/")
  ) 

#Removing "http_reference_data_gov_uk_id_year_" from the start of each each from 2002 to 2012
names(cancer_admissions_raw) <- str_remove_all(colnames(cancer_admissions_raw), "http_reference_data_gov_uk_id_year_")

#Removing first row from dataset
cancer_admissions_raw <- cancer_admissions_raw[-1,]

#Using pivot longer to create a column "year" for all columns 2002 - 2012 and another column count for values to come under
cancer_admissions <- cancer_admissions_raw %>% 
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "year", 
    values_to = "admissions_count")

#Writing cleaned datasets to csv files
write_csv(cerebrovascular_disease_admissions_clean, here("r_dashboard/clean_data/cerebrovascular_disease_admissions.csv"))

write_csv(coronary_heart_disease_admissions_clean, here("r_dashboard/clean_data/coronary_heart_disease_admissions.csv"))

write_csv(disease_digestive_system_admissions_clean, here("r_dashboard/clean_data/disease_digestive_system_admissions.csv"))

write_csv(respiratory_disease_hospital_admissions_clean, here("r_dashboard/clean_data/respiratory_disease_hospital_admissions.csv"))

write_csv(cancer_admissions, here("r_dashboard/clean_data/cancer_admissions.csv"))


#Filtering datasets to show total for Scotland as a whole over the years and combining all datasets
  cancer_admissions_scotland <- read_csv(here("r_dashboard/clean_data/cancer_admissions.csv")) %>% drop_na() %>% 
  filter(reference_area == "Scotland") %>% 
  mutate(longterm_condition = "cancer")
cbd_admissions_scotland <- read_csv(here("r_dashboard/clean_data/cerebrovascular_disease_admissions.csv"))  %>% 
  drop_na() %>% 
  filter(reference_area == "Scotland") %>% 
  mutate(longterm_condition = "cerebrovascular_disease")
chd_admissions_scotland <- read_csv(here("r_dashboard/clean_data/coronary_heart_disease_admissions.csv"))  %>% 
  drop_na() %>% 
  filter(reference_area == "Scotland") %>%
  mutate(longterm_condition = "coronary_heart_disease")
ddd_admissions_scotland <- read_csv(here("r_dashboard/clean_data/disease_digestive_system_admissions.csv"))  %>% 
  drop_na() %>% 
  filter(reference_area == "Scotland") %>% 
  mutate(longterm_condition = "disease_digestive_system")
respiratory_admissions_scotland <- read_csv(here("r_dashboard/clean_data/respiratory_disease_hospital_admissions.csv"))  %>% 
  drop_na() %>% 
  filter(reference_area == "Scotland") %>% 
  mutate(longterm_condition = "respiratory_conditions")

longterm_conditions_all <- bind_rows(cancer_admissions_scotland, cbd_admissions_scotland, chd_admissions_scotland, ddd_admissions_scotland, respiratory_admissions_scotland)

write_csv(longterm_conditions_all, here("r_dashboard/clean_data/longterm_conditions_all.csv"))
