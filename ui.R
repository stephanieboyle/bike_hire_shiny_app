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
            
            # fluidRow(
            #    column(12,
            #           tags$p("Please feel free to get in touch with any feedback or comments. You can contact me at the following places:"),
            #           tags$div(
            #              tags$ul(
            #                 tags$li("Email: stephanie.boyle9@gmail.com"),
            #                 tags$li("Twitter: ", tags$a("here", href = "https://twitter.com/_stephanieboyle")),
            #                 tags$li("LinkedIn: ", tags$a("here", href = "https://www.linkedin.com/in/stephanieboyle9/")) 
            #              )))
            # )

      tabItem(
         "overview",
         
         
      fluidRow(h4("  ")),
      
      fluidRow(
         column(1,
                " "), 
         
         column(4, 
                # date range selector
                dateRangeInput('dateRange',
                               label = 'Pick your date range:',
                               start = "2018-09-15", end = "2020-08-24", format = "yyyy-mm-dd")
                ),
         column(2,
                ""),
         column(5,
                  radioButtons("metrics", 
                   "Select metric",
                   choices = c("Number of journeys","Hours spent cycling"), 
                   inline = TRUE)
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