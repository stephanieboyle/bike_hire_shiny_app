
#-----------------------------------------------------
# make the maps
#-----------------------------------------------------
start_map <- start_stations %>%
  select(station_name, longitude, latitude) %>%
  rename(start_station_name = station_name, 
         start_long = longitude, 
         start_lat = latitude)

end_map <- end_stations %>%
  select(station_name, longitude, latitude) %>%
  rename(end_station_name = station_name, 
         end_long = longitude, 
         end_lat = latitude)