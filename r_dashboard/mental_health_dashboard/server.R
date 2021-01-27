#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(sf)
library(here)
library(scales)
library(leaflet)
library(htmltools)

#read in mental health data
all_time_mental <-read_csv(here::here("clean_data/all_time_mental.csv"))

#add labels
all_time_mental <- all_time_mental %>%
  mutate(
    leaflet_lb = paste(
      "<b>",
      la_name,
      "</b>" ,
      br(),
      " WEMWBS Score: ",
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



# Define server logic required to draw a histogram

server <- function(input, output) {
  
  output$map <- renderLeaflet({
 
    leaflet(scot_la_mh) %>%
      #add base tiles
      addProviderTiles("CartoDB.Positron") %>%
      # add swem score layer
      addPolygons(
        fillColor = ~ pal_swem(swem_score),
        color = "black",
        weight = 0.1,
        smoothFactor = 0.9,
        opacity = 0.8,
        fillOpacity = 0.9,
        label = ~ lapply(leaflet_lb, HTML),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        ),
        highlightOptions = highlightOptions(
          color = "#0C2C84",
          weight = 1,
          bringToFront = TRUE
        ),
        group = "Mental Health Score"
      ) %>%
      #add suicide layer
      addPolygons(
        fillColor = ~ pal_suicide(total_suicide_deaths),
        color = "black",
        weight = 0.1,
        smoothFactor = 0.9,
        opacity = 0.8,
        fillOpacity = 0.9,
        label =  ~ lapply(leaflet_lb, HTML),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        ),
        highlightOptions = highlightOptions(
          color = "#0C2C84",
          weight = 1,
          bringToFront = TRUE
        ),
        group = "Deaths due to Suicide"
      ) %>%
      #add legend for swem score
      addLegend(
        "bottomright",
        pal = pal_swem,
        values = ~ swem_score,
        title = "Average WEMWBS Score",
        opacity = 1,
        group = "Mental Health Score"
      ) %>%
      #add legend for suicide
      addLegend(
        "bottomright",
        pal = pal_suicide,
        values = ~ total_suicide_deaths,
        title = "Deaths from Suicide",
        opacity = 1,
        group = "Deaths due to Suicide",
        bins = 6
      ) %>%
      addLayersControl(
        position = c("bottomleft"),
        baseGroups = c("Mental Health Score", "Deaths due to Suicide"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      #set bounds of map
      fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])
    
    
    
  })
  
    
}