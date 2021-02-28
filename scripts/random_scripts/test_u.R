dashboardPage(
  dashboardHeader(title = "Bike Hire Data Explorer App"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("info-circle", lib = "font-awesome")),
      menuItem("Overview", tabName = "overview", icon = icon("map", lib = "font-awesome")),
      menuItem("Monthly breakdown", tabName = "monthly", icon = icon("calendar-alt", lib = "font-awesome")),
      menuItem("Weekly breakdown", tabName = "weekly", icon = icon("calendar", lib = "font-awesome")), 
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
                        "Currently the app does not connect directly to the Just Eat Cycles site and is manually refreshed. The data was last updated 02/11/2020." ),
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
          column(4,
                 " "), 
          
          column(5,
                 radioButtons("metrics", 
                              " ",
                              choices = c("Number of journeys","Hours spent cycling"), 
                              inline = TRUE)
          ),
          column(3, " ")
        ),
        
        fluidRow(
          column(12,
                 plotOutput("totals_plot")
          )
        ),
        
        br()
      ), 
      tabItem(
        "monthly",
        
        
        fluidRow(h4("  ")),
        
        
        fluidRow(
          infoBoxOutput("total_hours_spent"),
          infoBoxOutput("total_trips"), 
          infoBoxOutput("days_active")
        ),
        
        fluidRow(
          column(1,
                 " "),
          column(4,
                 dateRangeInput('dateRange',
                                label = paste('Pick your date Range'),
                                start = "2018-09-15", end = "2020-11-10",
                                min = "2018-09-14", max = "2020-11-11",
                                separator = " - ", format = "dd/mm/yy"),
          ),
          
          column(5,
                 radioButtons("metrics", 
                              " ",
                              choices = c("Number of journeys","Hours spent cycling"), 
                              inline = TRUE)
          ),
          column(1, " ")
        ),
        
        fluidRow(
          column(12,
                 plotOutput("totals_plot_monthly")
          )
        ),
        
        br()
        
      )
    )
  )
)