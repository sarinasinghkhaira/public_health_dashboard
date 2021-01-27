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
            
            #Tab 4 Freshwater Expert
            tabItem(tabName = "demographics",
                    h2("Who is affected"),
                    
                    fluidRow(
                        box(
                            title = "Alcohol Consumption", solidHeader = TRUE,
                            plotOutput("alc_shs_la_plot", height = 250), 
                            selectInput(
                                           inputId = "la_name_al",
                                           label = "Local Authority",
                                           choices = shs_la_nopivot$la_name,
                                           selected = NULL,
                                           multiple = FALSE,
                                           selectize = TRUE,
                                           width = NULL,
                                           size = NULL
                            ),
                                       
                            selectInput(
                                           inputId = "sex_al",
                                           label = "Sex",
                                           choices = shs_la_nopivot$sex,
                                           selected = NULL,
                                           multiple = FALSE,
                                           selectize = TRUE,
                                           width = NULL,
                                           size = NULL
                            )           
                        ), 
                            
                            
                        
                        
                        box(
                            title = "General Health", solidHeader = TRUE,
                            plotOutput("gh_shs_la_plot", height = 250), 
                            selectInput(
                                inputId = "la_name",
                                label = "Local Authority",
                                choices = shs_la_nopivot$la_name,
                                selected = NULL,
                                multiple = FALSE,
                                selectize = TRUE,
                                width = NULL,
                                size = NULL
                            ),
                            
                            selectInput(
                                inputId = "sex",
                                label = "Sex",
                                choices = shs_la_nopivot$sex,
                                selected = NULL,
                                multiple = FALSE,
                                selectize = TRUE,
                                width = NULL,
                                size = NULL
                            )           
                        ),
                        
                        box(
                            title = "Life Expectancy", solidHeader = TRUE,
                            plotOutput("")
                        )
                    )
            ),
            
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
