#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinydashboard)
library(leaflet)

ui <- dashboardPage(
    dashboardHeader(title = "Mental Health Dashboard"),
    ## Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Overview", tabName = "overview"),
            menuItem("Changes over time", tabName = "temporal"),
            menuItem("Where are the problems?", tabName = "geo"),
            menuItem("Who is affected", tabName = "demographics"),
            menuItem("Summary", tabName = "summary"),
            menuItem("About", tabName = "about")
        )
    ),
    ## Body content
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "overview",
                    h2("How is Scotland doing?"),
                    fluidRow(
                        tabBox(
                            title = "Life Expectancy",
                            side = "right",
                            id = "tabset1", height = 320,
                            tabPanel("Scotland", plotOutput("le_plot")),
                            tabPanel("UK", plotOutput("le_da_plot"))
                        ),
                        #tabPanel("Plot2", plotOutput("le_da_plot"))
                        
                        
                        box(
                            
                            
                            title = "Longterm Conditions", status = "primary", solidHeader = TRUE,
                            plotOutput("longterm_conditions_output", height = 320)
                            
                        ),
                        
                        box(
                            title = "Self-Reported Health", 
                            plotOutput("plot2", height = 320)
                        ),
                        
                        box(
                            title = "Mental Health", status = "primary", solidHeader = TRUE,
                            plotOutput("mh_time", height = 320)
                        )
                        
                        
                    )
            ),
            
            # Second tab content
            tabItem(tabName = "temporal",
                    h2("Changes over time"),
                    fluidRow(
                        box(
                            title = "Life Expectancy", 
                            plotOutput("plot4", height = 250),
                        )
                    )
            ),
            
            # Third tab content
            tabItem(tabName = "geo",
                    h2("Where are the problems?"),
                    fluidRow(
                        
                        leafletOutput("map", height = 500),
                        
                    )
            ),
            
            # Fourth tab content
            tabItem(tabName = "demographics",
                    h2("Who is affected"),
                    fluidRow(
                        box(
                            title = "Longterm Conditions and Mental Health", 
                            plotOutput("longterm_conditions_mental_health_plot", height = 250),
                        ),
                        
                        box(
                            title = "Life Expectancy",
                            plotOutput("plot7", height = 250),
                        ),
                        
                        box(
                            title = "Life Expectancy", 
                            plotOutput("plot8", height = 250),
                        )
                    )
            ),
            
            # Fifth tab content
            tabItem(tabName = "summary",
                    h2("Summary"),
                    fluidRow(
                        box(
                            title = "Life Expectancy",
                            plotOutput("plot9", height = 250),
                        )
                    )
            ),
            
            # Sixth tab content
            tabItem(tabName = "about",
                    h2("About"),
                    fluidRow(
                        
                    )
            )
        )
    )
)
