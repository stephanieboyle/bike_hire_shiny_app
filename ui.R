library(shiny)
library(shinydashboard)
library(lubridate)
library(leaflet)
library(shinythemes)
library(tidyverse)
library(dashboardthemes)


# Define UI  ----
ui <- dashboardPage(
  
  dashboardHeader(title = "Bike Hire Data Explorer App"),
  
 dashboardSidebar(
  
   br(),
   
   # date range selector
   dateRangeInput('dateRange',
                  label = 'Pick your date range:',
                  start = "2018-09-15", end = "2020-08-24", format = "yyyy-mm-dd"),
   
   radioButtons("metrics", 
                "Select metric",
                choices = c("Number of journeys","Hours spent cycling")),
   
   br(), 

            leafletOutput("big_map")

   # 
   # imageOutput("logo", height = 5, width = 5)
  ),
      

 dashboardBody(
   

   fluidRow(h4("  ")),
   
  
   fluidRow(
     column(12,
            plotOutput("totals_plot")
     )
   ),
   
   br(),
   
   fluidRow(
     infoBoxOutput("total_hours_spent"),
     
     infoBoxOutput("total_trips"), 
     
     infoBoxOutput("days_active")
   )

   
)
)

# 
#   fluidRow(
#     column(3,
#            
#            ),
#     
#     column(9,
# 
#            )
#   ),
#   fluidRow(
#     column(3,
#  
#            ),
#     column(9,
#            plotOutput("total_journey_plot")
#   )
#     
#     
#   )
# )
#       

#       
#       # sliderInput("slider1", h3("Sliders"),
#       #             min = 0, max = 100, value = 20),
#       
#       leafletOutput("big_map"),
#       
#       
#       # imageOutput("logo", height = 10, width = 10)
#       
#     ),
# 
#  
#   
#   mainPanel(
#  
#     plotOutput("total_time_plot")
#      
#   )
#   )
# )
#              
#  