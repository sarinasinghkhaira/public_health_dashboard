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
library(here)
library(tidyverse)
library(janitor)

here::here()

life <- read_csv(here("clean_data/le.csv"))
life_da <- read_csv(here("clean_data/le_da.csv"))

# Define server logic required to draw a histogram




server <- function(input, output) {
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

}