library(tidyverse)
library(leaflet)
library(lubridate)

#-------------------------------------------------
# load in the data
#-------------------------------------------------
all_data <- read_csv("clean_data/clean_data.csv") %>%
  arrange(year, month, date) %>%
  select(-c(started_at, ended_at))

#-------------------------------------------------
## distinct stations
#-------------------------------------------------
all_stations <- all_data %>% 
  pivot_longer(cols = c(start_station_name, end_station_name),
               names_to = "position",
               values_to = "station_name") %>%
  pivot_longer(cols = c(start_station_latitude, end_station_latitude),
               names_to = "lat_position",
               values_to = "latitude") %>%
  pivot_longer(cols = c(start_station_longitude, end_station_longitude),
               names_to = "long_position",
               values_to = "longitude") %>%
  select(station_name, longitude, latitude) 

stations <- all_stations %>%
  subset(!duplicated(station_name))
