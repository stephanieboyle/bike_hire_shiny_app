source("global.R")


#---------------------------------------------
# define the server
#---------------------------------------------
server <- function(input, output) {


  #--------------------------------------------------------------------------------
  # INTRO TAB
  #--------------------------------------------------------------------------------

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



  #--------------------------------------------------------------------------------
  # OVERVIEW TAB
  #-------------------------------------------------------------------------------

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

  output$totals_plot <- renderPlot({
    if(input$metrics == "Number of journeys"){
      ggplot(total_journey_month()) +
        aes(x = date, y = total_count) %>%
        geom_col(fill = "#0D87D5") +
        scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") +
        theme(axis.text.x=element_text(angle=60, hjust=1)) +
        xlab("") + ylab("  \n")  +
        ggtitle("\n Total number of monthly journeys taken")+
        scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE))
   }else{
     ggplot(total_hours()) +
       aes(x = date, y = total_hours) %>%
       geom_col(fill = "#0D87D5") +
       scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") +
       theme(axis.text.x=element_text(angle=60, hjust=1)) +
       xlab("") + ylab("  \n")  +
       ggtitle("\n Total number of monthly hours spent cycling") +
       scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE))
   }
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




  #--------------------------------------------------------------------------------
  #  BREAKDOWN TAB
  #--------------------------------------------------------------------------------

  output$top_months <- renderPlot({
    
    if(input$metrics_breakdown == "Number of journeys"){
    # total month hours plots
    ggplot(total_month) +
      aes(x = reorder(month_label, desc(total_count)), y = total_count) %>%
      geom_col(fill = "#FF8C00") +
      theme(axis.text.x=element_text(angle=60, hjust=1)) + 
      xlab("") + ylab("total journey count \n") +
        ggtitle("Most popular month of the year \n")
    }else{
    ggplot(total_month) +
      aes(x = reorder(month_label, desc(total_hours)), y = total_hours) %>%
      geom_col(fill = "#FF8C00") +
      theme(axis.text.x=element_text(angle=60, hjust=1)) + 
      xlab("") + ylab("total hours \n") + 
        ggtitle("Most popular month of the year \n")
    }
  })
  
  
  
  output$top_weekday <- renderPlot({
    
    if(input$metrics_breakdown == "Number of journeys"){
      # most popular day of the week 
      ggplot(weekday_pop) + 
        aes(x = reorder(weekday_label, desc(pop)), y = pop) + 
        geom_col(fill = "#FF8C00") +
        theme(axis.text.x=element_text(angle=60, hjust=1)) + 
        xlab("") + ylab("total journey count \n")  + 
        ggtitle("Most popular day of the week \n")
    }else{
    # most popular day of the week TIME SPENT
    ggplot(weekday_hours) + 
      aes(x = reorder(weekday_label, desc(pop_hours)), y = pop_hours) + 
      geom_col(fill = "#FF8C00") +
      theme(axis.text.x=element_text(angle=60, hjust=1)) + 
      xlab("") + ylab("total hours \n")  + 
      ggtitle("Most popular day of the week \n")
    }
  })
  
  
  
  
  #--------------------------------------------------------------------------------
  # STATION BREAKDOWN TAB
  #--------------------------------------------------------------------------------
  
    output$start_stations <- renderPlot({ 
      # most used start station
        ggplot(start_stations) +
        aes(x = reorder(station_name, desc(total_count)), total_count) +
        geom_col(fill = "yellowgreen") +
        theme(axis.text.x=element_text(angle=60, hjust=1)) +
        xlab("") + ylab("number of times used \n")  +
        ggtitle("Most popular start stations \n")
      })


  output$end_stations <- renderPlot({
    # most used end station
    ggplot(end_stations) +
      aes(x = reorder(station_name, desc(total_count)), total_count) +
      geom_col(fill = "#E3112B") +
      theme(axis.text.x=element_text(angle=60, hjust=1)) +
      xlab("") + ylab("number of times used \n")  +
      ggtitle("Most popular end stations \n")
  })
  

  # make a map for all stations
  output$start_map <- renderLeaflet({
    
  icons.start <- makeAwesomeIcon(icon = 'bicycle',
                                 markerColor = 'green',
                                 library='fa',
                                 iconColor = 'black')
  
  # make a map which has most popular start and stop stations in different colours
  leaflet(start_map) %>% 
    setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
    addTiles() %>%
    addAwesomeMarkers(lng = ~start_long, lat = ~start_lat, icon = icons.start, 
                      label = ~as.character(start_station_name))
  
  })
  
  output$end_map <- renderLeaflet({
    icons.end <- makeAwesomeIcon(icon = 'bicycle',
                                 markerColor = 'red',
                                 library='fa',
                                 iconColor = 'black')
    
    leaflet(end_map) %>% 
      setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
      addTiles() %>%
      addAwesomeMarkers(lng = ~end_long, lat = ~end_lat, icon = icons.end, 
                        label = ~as.character(end_station_name))
    
  })
  
} # end server
