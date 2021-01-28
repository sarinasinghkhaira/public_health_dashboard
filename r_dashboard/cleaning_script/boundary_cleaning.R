#Boundary lines from https://osdatahub.os.uk/downloads/open/BoundaryLine?_ga=2.224291931.1146669782.1611403147-115211834.1611403147

library(tidyverse)
library(sf)
library(rmapshaper)
library(here)

#Read in UK OS boundary shapefile
la_boundaries <- st_read("raw_data/district_borough_unitary_region.shp")

#Filter to select only data for Scotland
scot_la_boundaries <- la_boundaries %>% 
  mutate(area_code = as.character(CODE)) %>% 
  filter(str_detect(area_code, "^S")) 

#Simplify polygons to reduce run time to produce plots
scot_la_boundaries <- ms_simplify(input = scot_la_boundaries)

##Check projection, for use with leaflet must be WGS84
#st_crs(scot_la)
#Transform projection from Transverse Mercator to WGS84
scot_la_boundaries <- st_transform(scot_la_boundaries, '+proj=longlat +datum=WGS84')

#Write as new shapefile 
st_write(scot_la_boundaries, "clean_data/scot_la.shp", append = FALSE)





