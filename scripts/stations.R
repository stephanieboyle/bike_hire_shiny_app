
station_input <- 15

# most used start station
start_stations <- clean_data %>%
  rename(station_name = start_station_name) %>%
  group_by(station_name) %>%
  summarise(total_count = n()) %>% 
  arrange(desc(total_count)) %>%
  head(station_input) %>%
  left_join(stations, by = "station_name") %>%
  mutate(position = "start")

# most used end station
end_stations <- clean_data %>%
  rename(station_name = end_station_name) %>%
  group_by(station_name) %>%
  summarise(total_count = n()) %>% 
  arrange(desc(total_count)) %>%
  head(station_input) %>%
  left_join(stations, by = "station_name") %>%
  mutate(position = "end") 
