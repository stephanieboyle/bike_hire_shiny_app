library(tidyverse)
library(leaflet)
library(lubridate)
library(scales)
source("global.R")


#---------------------------------------------
# define the server 
#---------------------------------------------
server <- function(input, output) {
  
  # logo
  output$logo <- renderImage({
    return(list(src = "images/JE_New_Logo.png",contentType = "image/png",alt = "Alignment",width = 230,
                height = 225))
  }, deleteFile = FALSE)

  
  # ---- reactive data ----- #
  reactive_data <- reactive({
    all_data %>%
    filter(date >= input$dateRange[1] & date <= input$dateRange[2])
  })

  
  # ---- date range ---- # 
  output$dateRangeText  <- renderText({
    paste("input$dateRange is", 
          paste(as.character(input$dateRange), collapse = " to ")
    )
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

  # most popular day of the week time spent
  weekday_hours <- reactive({
    reactive_data() %>%
      group_by(weekday,weekday_label) %>%
      summarise(pop_mins = sum(mins), 
                pop_hours = pop_mins/60)
  })

  
  # most popular day of the week count
  weekday_pop <- reactive({
    reactive_data() %>%
      group_by(weekday,weekday_label) %>%
      summarise(pop = n())
  })
  
  
  total_journeys <- reactive({
    reactive_data() %>%
      group_by(year, month, month_label, weekday, weekday_label) %>%
      summarise(total_count = n()) %>%
      arrange(year, month) %>% 
      mutate(year_label = as.character(year), 
             date = make_date(year,month)) %>% 
      unite(col = "label", 
            c("month_label", "year_label"), 
            sep = "-")
  })

  
  # most used station
  most_used_stations <- reactive({
    all_stations %>%
      group_by(station_name) %>%
      summarise(totals = n()) %>%
      arrange(desc(totals))
  })

  station_input <-20
  
  # most used start station
  start_stations <- reactive({
    reactive_data() %>%
      rename(station_name = start_station_name) %>%
      group_by(station_name) %>%
      summarise(total_count = n()) %>% 
      arrange(desc(total_count)) %>%
      head(station_input) %>%
      left_join(stations, by = "station_name") %>%
      mutate(position = "start")
  })
  
  # most used end station
  end_stations <- reactive({
    reactive_data() %>%
      rename(station_name = end_station_name) %>%
      group_by(station_name) %>%
      summarise(total_count = n()) %>% 
      arrange(desc(total_count)) %>%
      head(station_input) %>%
      left_join(stations, by = "station_name") %>%
      mutate(position = "end") 
  })


  
  
  #-------------------------------------------------
  ## PLOTS
  #-------------------------------------------------
  
  output$totals_plot <- renderPlot({
    
    if(input$metrics == "Number of journeys"){
      ggplot(total_journey_month()) +
        aes(x = date, y = total_count) %>%
        geom_col(fill = "#072D79") +
        scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") +
        theme(axis.text.x=element_text(angle=60, hjust=1)) +
        xlab("") + ylab("total count \n")  +
        ggtitle("\n Total number of monthly journeys taken")
      

   }else{
    
     ggplot(total_hours()) +
       aes(x = date, y = total_hours) %>%
       geom_col(fill = "#072D79") +
       scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") + 
       theme(axis.text.x=element_text(angle=60, hjust=1)) + 
       xlab("") + ylab("total hours \n")  + 
       ggtitle("\n Total number of monthly hours spent cycling")
     
   }
  })




  # total month hours plots
 output$total_time_plot <- renderPlot({
   ggplot(total_hours()) +
     aes(x = date, y = total_hours) %>%
     geom_col(fill = "#E3112B") +
     scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") + 
     theme(axis.text.x=element_text(angle=60, hjust=1)) + 
     xlab("") + ylab("total hours \n")  + 
     ggtitle("Total hours spent cycling of Just Eat bikes")
   
 }) 
  
  # total month journey plots
  output$total_journey_plot <- renderPlot({
  ggplot(total_journey_month()) +
    aes(x = date, y = total_count) %>%
    geom_col(fill = "#DAA520") +
    scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") + 
    theme(axis.text.x=element_text(angle=60, hjust=1)) + 
    xlab("") + ylab("total count \n")  + 
    ggtitle("Total number of monthly journeys taken")
  })
  
  
  # most popular day of the week TIME SPENT
  output$weekday_hours_plot <- renderPlot({
  ggplot(weekday_hours()) + 
    aes(x = reorder(weekday_label,weekday), y = pop_hours) + 
    geom_col(fill = "#E3112B") +
    theme(axis.text.x=element_text(angle=60, hjust=1)) + 
    xlab("") + ylab("total hours \n")  + 
    ggtitle("Total hours spent by weekday")
  })
  
  # most popular day of the week 
  output$weekday_pop_plot <- renderPlot({
  ggplot(weekday_pop()) + 
    aes(x = reorder(weekday_label,weekday), y = pop) + 
    geom_col(fill = "#DAA520") +
    theme(axis.text.x=element_text(angle=60, hjust=1)) + 
    xlab("") + ylab("total journey count \n")  + 
    ggtitle("Total number of journeys by weekday")
  })
  
  
  # most used start station
  output$start_station_plot <- renderPlot({
  ggplot(start_stations()) + 
    aes(x = reorder(station_name, desc(total_count)), total_count) + 
    geom_col(fill = "yellowgreen") +
    theme(axis.text.x=element_text(angle=60, hjust=1)) + 
    xlab("") + ylab("number of times used \n")  + 
    ggtitle("Most popular start stations")
  })
  
  # most used end station
  output$end_station_plot <- renderPlot({
  ggplot(end_stations()) + 
    aes(x = reorder(station_name, desc(total_count)), total_count) + 
    geom_col(fill = "#E3112B") +
    theme(axis.text.x=element_text(angle=60, hjust=1)) + 
    xlab("") + ylab("number of times used \n")  + 
    ggtitle("Most popular end stations")
  })
  
  
  
  
  # make a map for all stations
  output$big_map <- renderLeaflet({
    
    start_map <- start_stations() %>%
      select(station_name, longitude, latitude) %>%
      rename(start_station_name = station_name, 
             start_long = longitude, 
             start_lat = latitude)
    
    end_map <- end_stations() %>%
      select(station_name, longitude, latitude) %>%
      rename(end_station_name = station_name, 
             end_long = longitude, 
             end_lat = latitude)
    
    icons.all <- awesomeIcons(
      icon = 'bicycle',
      iconColor = 'black',
      library = 'fa')
    
    leaflet(stations) %>% 
    setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
    addTiles() %>%
    addAwesomeMarkers(lng = ~longitude, lat = ~latitude, icon = icons.all)
  })
  
  
  
  # make a map which has most popular start and stop stations in different colours
  output$start_map <- renderLeaflet({
    
    icons.start <- makeAwesomeIcon(icon = 'bicycle', 
                                   markerColor = 'green', 
                                   library='fa',
                                   iconColor = 'black')

    leaflet(start_map) %>% 
      setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
      addTiles() %>%
      addAwesomeMarkers(lng = ~start_long, lat = ~start_lat, icon = icons.start)
  })

  
  
  output$end_map <- renderLeaflet({
    
    icons.end <- makeAwesomeIcon(icon = 'bicycle', 
                                 markerColor = 'red', 
                                 library='fa',
                                 iconColor = 'black')
    
    leaflet(end_map) %>% 
      setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
      addTiles() %>%
      addAwesomeMarkers(lng = ~end_long, lat = ~end_lat, icon = icons.end)
    
  })


  
  
  output$total_hours_spent<- renderInfoBox({
    
    hours_value <- reactive_data() %>%
      summarise(total_hours = round(sum(hours)))
    
    hours_valuef <- comma(hours_value$total_hours)
    
    infoBox(
      " ", value = paste(hours_valuef, 
                                            " hours spent cycling"
      ),
      icon = icon("clock"), color = "blue"
    )
  })
  
  output$total_trips <- renderInfoBox({
    trips_value <- reactive_data() %>%
      nrow()
    
    trips_valuef <- comma(trips_value)
    
    infoBox(
      " ", value = paste(trips_valuef, 
                                  " trips made by bike"
      ),
      icon = icon("map"), color = "green"
    )
  })
  
  
  output$days_active <- renderInfoBox({
    days_active <- reactive_data() %>%
      group_by(date) %>%
      summarise(count = n()) %>%
      nrow()
    
    
    infoBox(
      " ", value = paste(days_active, 
                         " days in use"
      ),
      icon = icon("calendar"), color = "yellow"
    )
  })
  
  
} # end server









