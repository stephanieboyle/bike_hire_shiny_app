
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


# logo
output$logo <- renderImage({
  return(list(src = "images/JE_New_Logo.png",contentType = "image/png",alt = "Alignment",width = 230,
              height = 225))
}, deleteFile = FALSE)
