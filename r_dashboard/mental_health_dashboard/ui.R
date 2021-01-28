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
library(dashboardthemes)

source("global.R")


ui <- dashboardPage(
    
    dashboardHeader(title = "Mental Health Dashboard"),
    ## Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Overview", tabName = "overview"),
            menuItem("Mental wellness over time", tabName = "temporal"),
            menuItem("Where are the problems?", tabName = "geo"),
            menuItem("Who is affected", tabName = "demographics"),
            menuItem("Mental Health Indicators", tabName = "mh_indicators"),
            menuItem("About", tabName = "about")
        )
    ),
    ## Body content
    dashboardBody(
        shinyDashboardThemes(theme = "poor_mans_flatly"),
        tabItems(
            # First tab content
            tabItem(tabName = "overview",
                    h2("How is Scotland doing?"),
                    fluidRow(
                        
                        
                        box(
 
                            title = "Longterm Conditions", status = "primary", solidHeader = TRUE,
                            plotOutput("longterm_conditions_output", height = 400)
                            
                        ),
                        
                        box(
                            title = "Self-Reported Health", status = "primary", solidHeader = TRUE,
                            plotOutput("general_health_plot", height = 400)
                        ),
                        
                    
                        tabBox(
                            title = "Life Expectancy",
                            side = "right",
                            id = "tabset1", 
                            tabPanel("Scotland", plotOutput("le_plot")),
                            tabPanel("UK", plotOutput("le_da_plot"))
                        ),
                        #tabPanel("Plot2", plotOutput("le_da_plot"))
                        
                        box(
                            title = "Mental Health", status = "primary", solidHeader = TRUE,
                            plotOutput("mh_time", height = 400)
                        )
                        
                    )
            ),
            
            # Second tab content
            tabItem(tabName = "temporal", 
                    h2("Mental wellness problems over time"),
                    fluidRow(
                        box(
                            title = "Deaths by Suicide", status = "primary", solidHeader = TRUE,
                            plotOutput("mw_deaths_s", height = 320),
                        ),
                        
                        box(
                          title = "Deaths by Dementia & Alzheimers", status = "primary", solidHeader = TRUE,
                          plotOutput("mw_deaths_d_a", height = 320),
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
                            background = "light-blue",
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
                             status = "primary",
                            plotOutput("gender_mh", height = 250)
                        ), 
                        
                        
                        box(
                            title = "Age", 
                            solidHeader = TRUE,
                             status = "primary",
                            plotOutput("age_mh", height = 250)
                        ), 
                        
                        box(
                            title = "Limiting Health Condition", 
                            solidHeader = TRUE,
                             status = "primary",
                            plotOutput("limiting_hc", height = 250)
                        ),
                        
                        box(
                            title = "House Ownership", 
                            solidHeader = TRUE,
                             status = "primary",
                            plotOutput("tenure_mh", height = 250)
                        )
                    )
            ),
            
            #Tab 5
            tabItem(tabName = "mh_indicators",
                    h1(""),
                    
                    fluidRow(
                        box(width = 12,
                            background = "light-blue",
                            column(width = 6, 
                                   selectInput(inputId = "area_shs",
                                               label = "Area",
                                               choices = sort(unique(shs_nopivot$la_name)),
                                               selected = "Aberdeen City"
                                   )
                            ),
                            
                            column(width = 6, 
                                   align = "center",
                                   radioButtons(inputId = "sex",
                                                label = "Sex",
                                                choices = unique(shs_nopivot$sex),
                                                selected = "All",
                                                inline = TRUE) 
                            )
                        )
                    ),
                    
                    fluidRow(
                        
                        box(
                            title = "Alcohol Use", 
                            solidHeader = TRUE,
                             status = "primary",
                            plotOutput("al_shs", height = 250)
                        ), 
                        
                        
                        box(
                            title = "Life Satisfaction", 
                            solidHeader = TRUE,
                             status = "primary",
                            plotOutput("lifesat_shs", height = 250)
                        ), 
                        
                        box(
                            title = "Activity Levels", 
                            solidHeader = TRUE,
                             status = "primary",
                            plotOutput("actlevels_shs", height = 250)
                        ),
                        
                        box(
                            title = "Longterm Conditions and Mental Health", 
                            plotOutput("longterm_conditions_mental_health_plot", 
                                       height = 250)
                        )
                    )
            ),

    
        
            
            # Sixth tab content
            tabItem(tabName = "about",
                    h1("About"),
                    fluidRow(
                        box(title = "Data Sources", solidHeader = TRUE, status = "primary",
                            h5(strong("Official Statistics Scotland")),
                            
                            tags$a(href="https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fmental-wellbeing-sscq", 
                                   "Mental Wellbeing Survey"),
                            br(),
                            tags$a(href="https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2FLife-Expectancy", 
                                   "Life Expectancy"),
                            br(),
                            tags$a(href="https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fgeneral-health-sscq", 
                                   "General Health Survey"),
                            br(),
                            tags$a(href = "https://www.gov.scot/publications/scottish-index-of-multiple-deprivation-2020v2-ranks/)",
                               "SIMD 2020"),
                            br(),
                            tags$a(href = "https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data",
                                   "Scottish Health Survey"),
                            br(),
                            tags$a(href = "https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fhospital-admissions",
                                   "Hospital Admissions"),
                            br(),
                            br(),
                            h5(strong("Other Data Sources")),
                            tags$a(href="nrscotland.gov.uk", 
                                   "National Records of Scotland"),
                            br(),
                            
                            tags$a(href="https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/deaths/suicides", 
                                   "NRS: Probable Suicides"),
                            br(),
                            tags$a(href="https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2FLife-Expectancy", 
                                   "NRS: Life Expectancy"),
                            br(),
                            tags$a(href = "https://osdatahub.os.uk/downloads/open/BoundaryLine?_ga=2.224291931.1146669782.1611403147-115211834.1611403147",
                                   "Ordinance Survey Boundaries"),
                            br(),
                            br(),
                            h5(strong("Additional Resources")),
                            
                            tags$a(href="https://www.gov.scot/publications/scotlands-public-health-priorities/pages/6/", 
                                   "Scotland's public health priority 3: Mental Wellbeing"),
                            br(),
                            
                            tags$a(href="https://warwick.ac.uk/fac/sci/med/research/platform/wemwbs/", 
                                   "Mental Health Score (WEMWBS/SWEMWBS)"),
                            
                    ),
                
                box(title = "Contributors",
                    solidHeader = TRUE,
                    status = "primary",
                    "Graeme Anderson",
                    br(),
                    "Stephanie Duncan",
                    br(),
                    "Rashpal Singh",
                    br(),
                    "Sarina Singh-Khaira",
                    br(),
                    br(),
                    "Code can be found at our ", tags$a(href = "https://github.com/sarinasinghkhaira/public_health_dashboard/",
                                                        "Github repo"))
                
              
                
            )
        )
    )
)
)