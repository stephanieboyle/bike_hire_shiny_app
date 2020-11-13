dashboardPage(
   dashboardHeader(title = "Bike Hire Data Explorer App"),
   dashboardSidebar(
      sidebarMenu(
         menuItem("Introduction", tabName = "intro", icon = icon("info-circle", lib = "font-awesome")),
         menuItem("Overview", tabName = "overview", icon = icon("bicycle", lib = "font-awesome")),
         menuItem("Details", tabName = "single", icon = icon("chart", lib = "font-awesome"))
      )
   ),
   
   dashboardBody(
      tabItems(
         
         tabItem(
            "intro", 
            fluidRow(
               column(12, 
                      h3("Welcome to the Edinburgh Bike Hire Data Explorer"),
                      div(class = "separator"),
                      tags$p("This app allows exploration and visualisation of bike hire data in Edinburgh. It uses information from the Just Eat
                             Cycles open web data.", 
                             tags$a("You can find the data, license, and data dictionary here.", 
                                    href = "https://edinburghcyclehire.com/open-data/historical")),
                      div(class = "separator")
               )
            ),
            
            fluidRow(
               column(12, 
                      leafletOutput("big_map")),
               br()
            )
         ), 

      tabItem(
         "overview",
         
         
      fluidRow(h4("  ")),
      
      fluidRow(
         column(6, 
                # date range selector
                dateRangeInput('dateRange',
                               label = 'Pick your date range:',
                               start = "2018-09-15", end = "2020-08-24", format = "yyyy-mm-dd")
                ),
         column(6,
                  radioButtons("metrics", 
                   "Select metric",
                   choices = c("Number of journeys","Hours spent cycling"))
         ),
      ),
      
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
 )
)