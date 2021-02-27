dashboardPage(
   dashboardHeader(title = "Bike Hire Data Explorer App"),
   dashboardSidebar(
      sidebarMenu(
         menuItem("Introduction", tabName = "intro", icon = icon("info-circle", lib = "font-awesome")),
         menuItem("Overview", tabName = "overview", icon = icon("map", lib = "font-awesome")),
         menuItem("Breakdown", tabName = "monthly", icon = icon("calendar-alt", lib = "font-awesome")),
         menuItem("Station Overview", tabName = "stations", icon = icon("bicycle", lib = "font-awesome"))
      )
   ),
   
   dashboardBody(
      tabItems(
         tabItem(
            "intro", 
            fluidRow(
               column(12, 
                      div(class = "separator"),
                      h4("Welcome to the Bike Hire Data Explorer App"),
                      tags$p("This app allows exploration and visualisation of data from the Just Eat Cycles hire bikes in Edinburgh. Their locations are on the map below. It uses information from the Just Eat
                             Cycles open web data.", 
                             tags$a("You can find the data, license, and data dictionary here.", 
                                    href = "https://edinburghcyclehire.com/open-data/historical"), 
                             "The code for this project ",tags$a("can be found on Github.", href = "https://github.com/stephanieboyle/bike_hire_shiny_app"), 
                             "Currently the app does not connect directly to the Just Eat Cycles site and is manually refreshed. The data was last updated Feb-2021." ),
                      div(class = "separator")

               )
            ),
            
            fluidRow(
               column(12, 
                      leafletOutput("big_map"))
            ), 
               br(), 
            tags$p("If you have any questions or feedback, feel free to get in touch! You can reach me at any of the options below.", align = "center"),
            br(),
            
            fluidRow(
               column(5, " "),
               column(1, 
                         socialButton(
                            url = "https://twitter.com/_stephanieboyle",
                            type = "twitter"
                         )
                      ),
               column(1,                         
                      socialButton(
                  url = "https://github.com/stephanieboyle",
                  type = "github")
               ), 
               column(1, 
                      socialButton(
                         url = "https://www.linkedin.com/in/stephanieboyle9/",
                         type = "linkedin")
                      ), 
               column(4, "")
            )
            ),
            
      tabItem(
         "overview",
         
         
      fluidRow(h4("  ")),
      
      
      fluidRow(
         infoBoxOutput("total_hours_spent"),
         infoBoxOutput("total_trips"), 
         infoBoxOutput("days_active")
      ),
      
      fluidRow(
         column(12,
                plotOutput("totals_plot")
         )
      ),
      br(),
      
      fluidRow(
         column(1,
                " "), 

         column(5,
                radioButtons("metrics", 
                             "Choose your metric",
                             choices = c("Number of journeys","Hours spent cycling"), 
                             selected = "Number of journeys", 
                             inline = TRUE)
         ),
            column(5,
                   dateRangeInput('dateRange',
                                  label = paste('Pick your date range'),
                                  start = "2018-09-15", end = "2021-02-26",
                                  min = "2018-09-14", max = "2021-02-27",
                                  separator = " - ", format = "dd/mm/yy"),
            ),
            
         column(1, " ")
      ),

      br()
     ),
     
     tabItem(
        "monthly",
          
        fluidRow(
           column(6,
                  plotOutput("top_months")
           ), 
           column(6, 
                  plotOutput("top_weekday")
                  )
        ),
        br(),
        fluidRow(
           column(4,
                  " ",
                  ),
           column(5,
                  radioButtons("metrics_breakdown", 
                               " ",
                               choices = c("Number of journeys","Hours spent cycling"), 
                               selected = "Number of journeys", 
                               inline = TRUE)
           ),
           column(3,
                  " ",
           )
        ),
        
        br()
      ), 
     
     tabItem(
        "stations",
        
        fluidRow(
           column(6,
                  plotOutput("start_stations")
                  ),
           column(6,
                  plotOutput("end_stations")
                  )
        ), 
        fluidRow(
           column(6, 
                  leafletOutput("start_map")
                  ), 
           column(6,
                  leafletOutput("end_map")
                  )
           )
        )
     )
   )
 )

