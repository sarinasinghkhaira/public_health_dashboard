library(shiny)
library(shinydashboard)



server <- function(input, output) {

    
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
    
    
}    
