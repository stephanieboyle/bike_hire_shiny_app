source("global.R")


#---------------------------------------------
# define the server 
#---------------------------------------------
server <- function(input, output) {
  
  
  # ---- date range input ---- # 
  output$dateRangeText  <- renderText({
    paste("input$dateRange is", 
          paste(as.character(input$dateRange), collapse = " to ")
    )
  })
  
  
  # ---- reactive data, output from date range ----- #
  reactive_data <- reactive({
    clean_data %>%
      filter(date >= input$dateRange[1] & date <= input$dateRange[2])
  })
  
  
  #----------- TOTAL JOURNEY ANALYSIS --------------#
  # total hours by month
  total_hours <- reactive({
    reactive_data() %>%
      group_by(year, month, month_label) %>%
      summarise(total_mins = sum(mins), 
                total_hours = total_mins/60) %>%
      arrange(year, month) %>% 
      mutate(year_label = as.character(year), 
             date = make_date(year,month)) %>% 
      unite(col = "label", 
            c("month_label", "year_label"), 
            sep = "-")
  })
  
  # total journeys by month
  total_journey_month <- reactive({ 
    reactive_data() %>%
      group_by(year, month, month_label) %>%
      summarise(total_count = n()) %>%
      arrange(year, month) %>% 
      mutate(year_label = as.character(year), 
             date = make_date(year,month)) %>% 
      unite(col = "label", 
            c("month_label", "year_label"), 
            sep = "-")
  })
  
  
  
  #-------------------------------------------------
  ## PLOTS
  #-------------------------------------------------
  
  output$totals_plot <- renderPlot({
    
    if(input$metrics == "Number of journeys"){
      ggplot(total_journey_month()) +
        aes(x = date, y = total_count) %>%
        geom_col(fill = "#0D87D5") +
        scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") +
        theme(axis.text.x=element_text(angle=60, hjust=1)) +
        xlab("") + ylab("total count \n")  +
        ggtitle("\n Total number of monthly journeys taken")+ 
        scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE))
      
      
    }else{
      
      ggplot(total_hours()) +
        aes(x = date, y = total_hours) %>%
        geom_col(fill = "#0D87D5") +
        scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") + 
        theme(axis.text.x=element_text(angle=60, hjust=1)) + 
        xlab("") + ylab("total hours \n")  + 
        ggtitle("\n Total number of monthly hours spent cycling") + 
        scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE))
      
    }
  })
  
  
  
  
  
  # make a map for all stations
  output$big_map <- renderLeaflet({
    
    icons.all <- awesomeIcons(
      icon = 'bicycle',
      iconColor = 'black',
      library = 'fa')
    
    leaflet(stations) %>% 
      setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
      addTiles() %>%
      addAwesomeMarkers(lng = ~longitude, lat = ~latitude, icon = icons.all,
                        label = ~as.character(station_name))
  })
  
  
  
  output$total_hours_spent<- renderInfoBox({
    hours_value <- reactive_data() %>%
      summarise(total_hours = round(sum(hours)))
    hours_valuef <- scales::comma(hours_value$total_hours)
    infoBox(" ",
            value = paste(hours_valuef,
                          " hours spent cycling"),
            icon = icon("clock"), color = "orange"
    )
  })
  
  output$total_trips <- renderInfoBox({
    trips_value <- reactive_data() %>%
      nrow()
    trips_valuef <- scales::comma(trips_value)
    infoBox(
      " ",
      value = paste(trips_valuef, 
                    " trips made by bike"),
      icon = icon("map"), color = "green")
  })
  
  
  output$days_active <- renderInfoBox({
    days_active <- reactive_data() %>%
      group_by(date) %>%
      summarise(count = n()) %>%
      nrow()
    infoBox(
      " ", 
      value = paste(days_active, 
                    " days in use"),
      icon = icon("calendar"), color = "purple")
  })
  
  
} # end server









