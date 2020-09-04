library(shiny)
library(shinydashboard)
library(lubridate)
library(leaflet)
library(maps)
library(shinythemes)
library(dashboardthemes)
library(tidyverse)
library(shinydashboard)


source("scripts/data_analysis.R")


# Define UI  ----
ui <- dashboardPage(
  
  # App title ----
  dashboardHeader("Bike Hire Data Explorer App"),
  
  hr(),
  
  dashboardSidebar(
    
    # date range selector
    dateRangeInput('dateRange',
                   label = 'Pick your date range:',
                   start = "2018-09-15", end = "2020-08-24", format = "dd/mm/yyyy")
    
    ),
    
  dashboardBody(
    
    shinyDashboardThemes("grey_dark"),
    
    fluidRow(
      
      column(10, 
             )
      
      
    )
  )
  
  # make a map for all stations
  leaflet(stations) %>% 
    setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
    addTiles() %>%
    addAwesomeMarkers(lng = ~longitude, lat = ~latitude, icon = icons.all),
  
  hr(),
  
  # create a sidebar
  
 fluidRow(
   column(4,
          "Date Choice", 
          
 )
)


    # # Main panel for displaying outputs ----
    # mainPanel(

      # # Output: bar chat ----
      # plotOutput(outputId = "total_hours")



# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  output$total_hours <- renderPlot({
    
    # total hours
    total_hours <- data %>%
      group_by(year, month, month_label) %>%
      summarise(total_mins = sum(mins), 
                total_hours = total_mins/60) %>%
      arrange(year, month) %>% 
      mutate(year_label = as.character(year), 
             date = make_date(year,month)) %>% 
      unite(col = "label", 
            c("month_label", "year_label"), 
            sep = "-")
    
    ggplot(total_hours) +
      aes(x = date, y = total_hours) %>%
      geom_col(fill = "#1b3445") +
      scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") + 
      theme(axis.text.x=element_text(angle=60, hjust=1)) + 
      xlab("") + ylab("total hours \n")  + 
      ggtitle("Total hours spent on bike hire")
    
  })
  
}

shinyApp(ui, server)