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
library(janitor)



#Reading in longterm conditions dataset
longterm_conditions_all <- read_csv(here("clean_data/longterm_conditions_all.csv"))

#Reading in general health survey dataset
longterm_conditions_mental_health <- read_csv(here("clean_data/general_health.csv"))

longterm_conditions_mental_health <- longterm_conditions_mental_health %>% 
  mutate(
    limiting_long_term_physical_or_mental_health_condition = if_else(limiting_long_term_physical_or_mental_health_condition == "Limiting condition", "Yes", limiting_long_term_physical_or_mental_health_condition),
    limiting_long_term_physical_or_mental_health_condition = if_else(limiting_long_term_physical_or_mental_health_condition == "No limiting condition", "No", limiting_long_term_physical_or_mental_health_condition)
  ) %>% 
  drop_na()


#read in life expectancy data
life <- read_csv(here("clean_data/le.csv"))
life_da <- read_csv(here("clean_data/le_da.csv"))

#read in mental health data
all_time_mental <-read_csv(here::here("clean_data/all_time_mental.csv"))

#read in temporal mh data
npf_mental_wellbeing <- read_csv(
  here::here("clean_data/npf_mental_health.csv"))

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
  
####### Overview life expectancy plot 
  
  output$le_plot <- renderPlot({
    life %>%
      #filter for Scotland overall data
      filter(feature_code == "S92000003") %>%
      group_by(date_code, age_num_first) %>%
      #filter to include a subset of ages
      filter(age_num_first == 0 | age_num_first == 25
             | age_num_first == 50 | age_num_first == 75 |
               age_num_first == 90) %>%
      #ind the average life expectancy for each age group
      summarise(avg_le = mean(life_expectancy)) %>%
      #plot a line graph, differentiate by age group
      ggplot(aes(x = date_code, y = avg_le, group = age_num_first, colour = age_num_first)) +
      geom_line() +
      #add points
      geom_point(size=2, shape=21, fill="white") +
      theme(axis.text.x = element_text( angle = 90,  hjust = 1 )) +
      labs(
        y = "Life Expectancy (years)",
        x = "Date",
        colour = "Age"
      ) +
      ggtitle("Life Expectancy") +
      theme(plot.title=element_text(hjust = 0.5, family="serif",
                                    colour="darkred", size= 18, face = "bold")) +
      scale_y_continuous(
        breaks = seq(70, 95, by = 1)
      ) +
      #remove legend
      theme(legend.position="none") +
      #add labels for each age group included
      annotate("text", x= 3, y= 93, label="Age 90", family="serif",
               fontface="italic", colour="darkred", size= 3 ) +
      annotate("text", x= 3, y= 85, label="Age 75-79", family="serif",
               fontface="italic", colour="darkred", size= 3) +
      annotate("text", x= 3, y= 78.5, label="Age 50-54", family="serif",
               fontface="italic", colour="darkred", size= 3) +
      annotate("text", x= 3, y= 76.5, label="Age 25-29", family="serif",
               fontface="italic", colour="darkred", size= 3) +
      annotate("text", x= 3, y= 74, label="Age 0", family="serif",
               fontface="italic", colour="darkred", size= 3)
    
  })
  
  output$le_da_plot <- renderPlot({
    life_da %>% 
      group_by(country, year) %>%
      #include overall data for the UK
      filter(country != "United Kingdom") %>% 
      #find average life expectancy
      summarise(life_expectancy = mean(life_expect_4)) %>% 
      #plot a line graph, differentiate by country
      ggplot(aes(x = year, y = life_expectancy, group = country, colour = country)) +
      geom_line() +
      geom_point(size=2, shape=21, fill="white") +
      theme(axis.text.x = element_text( angle = 90,  hjust = 1 )) +
      labs(
        y = "Life Expectancy (years)",
        x = "Date"
      ) +
      ggtitle("Life Expectancy for UK Nations") +
      theme(plot.title=element_text(hjust = 0.5, family="serif",
                                    colour="darkred", size= 18, face = "bold"))
    
    
    
    
  })
##################First tab content, longterm conditions plot
  output$longterm_conditions_output <- renderPlot({
    
    longterm_conditions_all %>% 
      ggplot() +
      aes(x = year, y = admissions_count, colour = longterm_condition) +
      geom_line() +
      labs(title = "Hospital Admissions by Long Term Condition",
           subtitle = "2002 - 2012",
           x = "Year",
           y = "Admissions Count") +
      scale_x_continuous(breaks = c(2002:2012)) +
      scale_color_manual(name = "Longterm Condition",
                         labels = c("Cancer", "Cerebrovascular Disease", "Coronary Heart Disease", "Disease Digestive System", "Respiratory Conditions"),
                         values = c("red", "dark green", "blue", "orange", "purple")) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      scale_y_continuous(breaks = c(0, 25000, 50000, 75000, 100000, 125000, 150000, 175000)) +
      theme_light()
    
  })
  
  
  
################## Overview: Mental Health Over Time Plot  
  output$mh_time <- renderPlot({
    
    npf_mental_wellbeing %>% 
      filter(characteristic == "Total") %>% 
      ggplot(aes(x = year, y = figure)) +
      geom_line() +
      geom_point(size=2, shape=21, fill="white") +
      scale_x_continuous(breaks = seq(min(npf_mental_wellbeing$year), 
                                      max(npf_mental_wellbeing$year)),  
                         labels = seq(min(npf_mental_wellbeing$year), 
                                      max(npf_mental_wellbeing$year))) +
      labs(x = "Year",
           y = "Average WEMWBS Score", 
           title = "Average Mental Wellbeing Score in Scotland",
           subtitle = "Average WEMWBS Score 2006 - 2019") +
      theme_minimal()
    
    
    
  })
  
################## Where: mental health map  
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
      fitBounds(bbox[1], bbox[2], bbox[3], bbox[4]) %>%
      setView(lat = 56.610003, lng = -4.2, zoom = 7)

  })
  
################### Demographics
  
  mental_wb_to_plot <- reactive({
    mental_wb %>% 
      filter(la_name == input$area,
             date_code == input$year)
  })
  
  
  output$gender_mh <- renderPlot({
    
    mental_wb_to_plot() %>%
      filter(gender != "All") %>%
      ggplot() +
      aes(x = gender, y = mean) +
      geom_pointrange(aes(ymin = lower_ci, ymax = upper_ci)) +
      theme_bw() +
      labs(x = NULL,
           y = "Mean SWEMWBS Score")
    
  })
  
  output$age_mh <- renderPlot({
    
    mental_wb_to_plot() %>%
      filter(age != "All") %>%
      ggplot() +
      aes(x = age, y = mean) +
      geom_pointrange(aes(ymin = lower_ci, ymax = upper_ci)) +
      theme_bw() +
      labs(x = NULL,
           y = "Mean SWEMWBS Score")
    
  })
  
  output$limiting_hc <- renderPlot({
    
    mental_wb_to_plot() %>%
      filter(limiting_cond != "All") %>%
      ggplot() +
      aes(x = limiting_cond, y = mean) +
      geom_pointrange(aes(ymin = lower_ci, ymax = upper_ci)) +
      theme_bw() +
      labs(x = NULL,
           y = "Mean SWEMWBS Score")
    
  })
  
  output$tenure_mh <- renderPlot({
    mental_wb_to_plot() %>%
      filter(type_of_tenure != "All") %>%
      ggplot() +
      aes(x = type_of_tenure, y = mean) +
      geom_pointrange(aes(ymin = lower_ci, ymax = upper_ci)) +
      theme_bw() +
      labs(x = NULL,
           y = "Mean SWEMWBS Score")
    
  })
  
  
  
############Fourth tab content - Self Assessed & Longterm Conditions
  output$longterm_conditions_mental_health_plot <- renderPlot({
    
    longterm_conditions_mental_health %>% 
      filter(measurement == "Percent") %>%  
      #filtering to remove "All" in limiting_long_term_physical_or_mental_health_condition column 
      filter(!limiting_long_term_physical_or_mental_health_condition == "All") %>% 
      select(-household_type, -type_of_tenure, -age, -feature_code, -units) %>% 
      group_by(gender, value, self_assessed_general_health, limiting_long_term_physical_or_mental_health_condition) %>% 
      summarise() %>% 
      group_by(self_assessed_general_health, limiting_long_term_physical_or_mental_health_condition) %>% 
      summarise(mean_self_assessment_value = mean(value)) %>% 
      ggplot() +
      geom_col(aes(x = limiting_long_term_physical_or_mental_health_condition, y = mean_self_assessment_value, fill = self_assessed_general_health)) +
      labs(title = "Self Assessed General Health in Scotland",
           subtitle = "2012 - 2019",
           x = "Limiting Long Term Physical or Mental Health Condition",
           y = "Mean Self Assessment Value",
           fill = "Self Assessed General Health") 
    
  })
  
}