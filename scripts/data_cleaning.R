library(tidyverse)
library(lubridate)
library(janitor)
library(here)

# get a list of files
files <- list.files(path = here("./raw_data/"),
                    pattern = "*.csv", 
                    full.names = T) 

test <- read_csv("raw_data/")
# read in the files 
all_data <- sapply(files, read_csv, simplify=FALSE) %>% 
  bind_rows(.id = "id")

# add in some more info about the dates and times 
clean_data <- all_data %>%
  mutate(year = year(started_at), 
         month = month(started_at),
         month_label = month(started_at, label = TRUE, abbr = TRUE), 
         day = day(started_at), 
         date = date(started_at),
         weekday = wday(started_at),
         weekday_label = wday(started_at, label = TRUE),
         am = am(started_at), 
         mins = duration / 60, 
         hours = mins / 3600, 
         seconds = duration) %>%
  select(year, month, month_label, date, day, weekday, weekday_label, mins, hours, seconds, started_at, ended_at, 
         start_station_id, start_station_name, start_station_latitude, start_station_longitude,
         end_station_id, end_station_name, end_station_latitude, end_station_longitude,
         start_station_description, end_station_description) %>%
  arrange(date)


rm(all_data, files)

#-------------------------------------------------
## distinct stations
#-------------------------------------------------
all_stations <- clean_data %>% 
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

write.csv(clean_data, "clean_data/clean_data.csv", row.names = FALSE)
write.csv(stations, "clean_data/stations.csv", row.names = FALSE)
