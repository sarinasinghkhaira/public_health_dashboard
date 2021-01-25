#Boundary lines from https://osdatahub.os.uk/downloads/open/BoundaryLine?_ga=2.224291931.1146669782.1611403147-115211834.1611403147

library(tidyverse)
library(sf)
library(rmapshaper)

#Read in UK OS boundary shapefile
la_boundaries <- st_read("raw_data/district_borough_unitary_region.shp")

#Filter to select only data for Scotland
scot_la_boundaries <- la_boundaries %>% 
  mutate(area_code = as.character(CODE)) %>% 
  filter(str_detect(area_code, "^S")) 

#Simplify polygons to reduce run time to produce plots
scot_la_boundaries <- ms_simplify(input = scot_la_boundaries)

#Write as new shapefile 
st_write(scot_la_boundaries, "clean_data/scot_la.shp")
