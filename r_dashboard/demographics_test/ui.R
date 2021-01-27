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
            menuItem("Summary", tabName = "summary"),
            menuItem("About", tabName = "about")
        )
    ),
    ## Body content
    dashboardBody(
        #Tab 1 
        tabItems(
            tabItem(tabName = "overview", 
                    h2("Overview"),
                    fluidRow(
                        box(
                            title = "Life Expectancy", solidHeader = TRUE,
                            plotOutput("")
                        ),
                        box(
                            title = "Longterm Conditions", solidHeader = TRUE,
                            plotOutput("")
                        ),
                        box(
                            title = "Decision Variables", solidHeader = TRUE,
                            plotOutput("")
                        )
                    )
            ),
            #Tab 2 
            tabItem(tabName = "temporal",
                    h2("Changes over time"),
                    fluidRow(
                        box(
                            title = "CHanges over time", solidHeader = TRUE,
                            plotOutput("")
                        )
                    )
            ),
            
            #Tab 3 
            tabItem(tabName = "geo",
                    h2("Where are the problems?"),
                    fluidRow(
                        box(
                            title = "Life Expectancy", solidHeader = TRUE,
                            plotOutput("")
                        )
                    )
            ),
###########################            
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
########################### 

            #Tab 5 Environmental Damages
            tabItem(tabName = "summary",
                    h2("Summary"),
                    fluidRow(
                        box(
                            title = "Life Expectancy", status = "primary", solidHeader = TRUE,
                            plotOutput("", height = 250)
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
