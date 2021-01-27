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

# Define server logic required to draw a histogram

server <- function(input, output) {
    
   
    output$alc_shs_la_plot <- renderPlot({
      
        
        
         shs_la_nopivot %>%
            
            filter(str_detect(scottish_health_survey_indicator, "^Alcohol consumption*")) %>% 
            filter(la_name == input$la_name_al) %>%
            filter(sex == input$sex_al) %>% 
            ggplot(aes(x = date_code, y = value, fill = scottish_health_survey_indicator)) +
            geom_bar(stat="identity") +
            geom_text(aes(y=value, label = ""),
                      position = position_stack(vjust = 0.5), colour="white")
    
      output$gh_shs_la_plot <- renderPlot({        
      
      shs_la_nopivot%>% 
        filter(str_detect(scottish_health_survey_indicator, "^General health*")) %>% 
        filter(la_name == input$la_name) %>%
        filter(sex == input$sex) %>% 
        ggplot(aes(x = date_code, y = value, fill = scottish_health_survey_indicator)) +
        geom_bar(stat="identity") +
        geom_text(aes(y=value, label = ""),
                  position = position_stack(vjust = 0.5), colour="white")
    
    })
  })
}    