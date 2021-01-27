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

source("global.R")


ui <- dashboardPage(
    dashboardHeader(title = "Mental Health Dashboard"),
    ## Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Overview", tabName = "overview"),
            menuItem("Changes over time", tabName = "temporal"),
            menuItem("Where are the problems?", tabName = "geo"),
            menuItem("Who is affected", tabName = "demographics"),
            menuItem("Self Assessed Health", tabName = "self_assessed"),
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
            #Tab 4 Freshwater Expert
            tabItem(tabName = "demographics",
                    h1("Who is affected"),
                    
                    fluidRow(
                        box(width = 12,
                            background = "blue",
                            column(width = 6, 
                                   selectInput(inputId = "area",
                                               label = "Area",
                                               choices = unique(mental_wb$la_name),
                                               selected = "Scotland"
                                   )
                            ),
                            
                            column(width = 6, 
                                   align = "center",
                                   radioButtons(inputId = "year",
                                                label = "Year",
                                                choices = c(2014:2017),
                                                selected = "2016",
                                                inline = TRUE) 
                            )
                        )
                    ),
                    
                    fluidRow(
                        
                        box(
                            title = "Gender", 
                            solidHeader = TRUE,
                            status = "warning",
                            plotOutput("gender_mh", height = 250)
                        ), 
                        
                        
                        box(
                            title = "Age", 
                            solidHeader = TRUE,
                            status = "warning",
                            plotOutput("age_mh", height = 250)
                        ), 
                        
                        box(
                            title = "Limiting Health Condition", 
                            solidHeader = TRUE,
                            status = "warning",
                            plotOutput("limiting_hc", height = 250)
                        ),
                        
                        box(
                            title = "House Ownership", 
                            solidHeader = TRUE,
                            status = "warning",
                            plotOutput("tenure_mh", height = 250)
                        )
                    )
            ),

            # Fourth tab content
            tabItem(tabName = "self_assessed",
                    h2("Self Assessed General Health"),
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
