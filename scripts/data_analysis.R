


#-------------------------------------------------
## monthly data
#-------------------------------------------------

total_month_year <- clean_data %>%
  group_by(year, month) %>%
  summarise(total_mins = sum(mins), 
            total_hours = total_mins/60, 
            total_count = n()) %>%
  mutate(month_label = month(month, label = TRUE, abbr = TRUE))

total_month <- clean_data %>%
  group_by(month) %>%
  summarise(total_mins = sum(mins), 
            total_hours = total_mins/60, 
            total_count = n()) %>%
  mutate(month_label = month(month, label = TRUE, abbr = TRUE))


# total month hours plots
ggplot(total_month) +
  aes(x = month_label, y = total_count) %>%
  geom_col(fill = "#E3112B") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  xlab("") + ylab("total count \n") 

ggplot(total_month) +
  aes(x = month_label, y = total_hours) %>%
  geom_col(fill = "#E3112B") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  xlab("") + ylab("total hours \n") 








# total hours by month
total_hours <- reactive_data %>%
  group_by(year, month, month_label) %>%
  summarise(total_mins = sum(mins), 
            total_hours = total_mins/60) %>%
  arrange(year, month) %>% 
  mutate(year_label = as.character(year), 
         date = make_date(year,month)) %>% 
  unite(col = "label", 
        c("month_label", "year_label"), 
        sep = "-")

# total journeys by month
total_journey_month <- reactive_data %>%
  group_by(year, month, month_label) %>%
  summarise(total_count = n()) %>%
  arrange(year, month) %>% 
  mutate(year_label = as.character(year), 
         date = make_date(year,month)) %>% 
  unite(col = "label", 
        c("month_label", "year_label"), 
        sep = "-")


#----------------------------------
# WEEKDAY ANALYSIS ----------------
#----------------------------------

# most popular day of the week time spent
weekday_hours <- reactive_data %>%
  group_by(weekday,weekday_label) %>%
  summarise(pop_mins = sum(mins), 
            pop_hours = pop_mins/60)

# most popular day of the week count
weekday_pop <- reactive_data %>%
  group_by(weekday,weekday_label) %>%
  summarise(pop = n())



#----------------------------------
# ALL DATE ANALYSIS ---------------
#----------------------------------
total_journeys <- reactive_data %>%
  group_by(year, month, month_label, weekday, weekday_label) %>%
  summarise(total_count = n()) %>%
  arrange(year, month) %>% 
  mutate(year_label = as.character(year), 
         date = make_date(year,month)) %>% 
  unite(col = "label", 
        c("month_label", "year_label"), 
        sep = "-")

#----------------------------------
# STATION ANALYSIS ----------------
#----------------------------------

station_input <- 20

# most used station
most_used_stations <- all_stations %>%
  group_by(station_name) %>%
  summarise(totals = n()) %>%
  arrange(desc(totals)) %>%
  head(station_input)

# most used start station
start_stations <- reactive_data %>%
  rename(station_name = start_station_name) %>%
  group_by(station_name) %>%
  summarise(total_count = n()) %>% 
  arrange(desc(total_count)) %>%
  head(station_input) %>%
  left_join(stations, by = "station_name") %>%
  mutate(position = "start")

# most used end station
end_stations <- reactive_data %>%
  rename(station_name = end_station_name) %>%
  group_by(station_name) %>%
  summarise(total_count = n()) %>% 
  arrange(desc(total_count)) %>%
  head(station_input) %>%
  left_join(stations, by = "station_name") %>%
  mutate(position = "end") 


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



#-------------------------------------------------
## PLOTS
#-------------------------------------------------

# total month hours plots
ggplot(total_hours) +
  aes(x = date, y = total_hours) %>%
  geom_col(fill = "#E3112B") +
  scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") + 
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  xlab("") + ylab("total hours \n")  + 
  ggtitle("Total hours spent cycling of Just Eat bikes")

# total month journey plots
ggplot(total_journey_month) +
  aes(x = date, y = total_count) %>%
  geom_col(fill = "#DAA520") +
  scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") + 
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  xlab("") + ylab("total count \n")  + 
  ggtitle("Total number of monthly journeys taken")


# most popular day of the week TIME SPENT
ggplot(weekday_hours) + 
  aes(x = reorder(weekday_label,weekday), y = pop_hours) + 
  geom_col(fill = "#E3112B") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  xlab("") + ylab("total hours \n")  + 
  ggtitle("Total hours spent by weekday")


# most popular day of the week 
ggplot(weekday_pop) + 
  aes(x = reorder(weekday_label,weekday), y = pop) + 
  geom_col(fill = "#DAA520") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  xlab("") + ylab("total journey count \n")  + 
  ggtitle("Total number of journeys by weekday")



# most used start station
  ggplot(start_stations) + 
  aes(x = reorder(station_name, desc(total_count)), total_count) + 
  geom_col(fill = "yellowgreen") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  xlab("") + ylab("number of times used \n")  + 
  ggtitle("Most popular start stations")

# most used end station
  ggplot(end_stations) + 
  aes(x = reorder(station_name, desc(total_count)), total_count) + 
  geom_col(fill = "#E3112B") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  xlab("") + ylab("number of times used \n")  + 
  ggtitle("Most popular end stations")



#-------------------------------------------------
## make a map
#-------------------------------------------------
icons.all <- awesomeIcons(
  icon = 'bicycle',
  iconColor = 'black',
  library = 'fa')

icons.start <- makeAwesomeIcon(icon = 'bicycle', 
                               markerColor = 'green', 
                               library='fa',
                               iconColor = 'black')

icons.end <- makeAwesomeIcon(icon = 'bicycle', 
                               markerColor = 'red', 
                               library='fa',
                               iconColor = 'black')

# make a map for all stations
leaflet(stations) %>% 
  setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
  addTiles() %>%
  addAwesomeMarkers(lng = ~longitude, lat = ~latitude, icon = icons.all)



# make a map which has most popular start and stop stations in different colours
leaflet(start_map) %>% 
  setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
  addTiles() %>%
  addAwesomeMarkers(lng = ~start_long, lat = ~start_lat, icon = icons.start)


leaflet(end_map) %>% 
  setView(lng = -3.1883, lat = 55.9533, zoom = 12)%>%
  addTiles() %>%
  addAwesomeMarkers(lng = ~end_long, lat = ~end_lat, icon = icons.end)
  







# 
# starts <- pivoted_data %>% 
#   filter(lat_position == "start_station_latitude") %>%
#   mutate(position = "start") %>%
#   select(-lat_position, -long_position, -station_position, -id_position, 
#          -station_desc, -desc_position, -started_at, -ended_at)
#   
# ends <- pivoted_data %>% 
#   filter(lat_position == "end_station_latitude") %>%
#   mutate(position = "end") %>%
#   select(-lat_position, -long_position, -station_position, -id_position, 
#          -station_desc, -desc_position, -started_at, -ended_at)
# 
# all_pivot <- bind_rows(starts, ends)
# 
# rm(starts,ends, pivoted_data)
# 
# 
# start_labels <- all_data %>%
#   distinct(start_station_name, start_station_latitude, start_station_longitude) %>%
#   rename(station_name = start_station_name, 
#          station_latitude = start_station_latitude, 
#          station_longitude = start_station_longitude) %>%
#   mutate(position = "start")
# 
# end_labels <- all_data %>%
#   distinct(end_station_name, end_station_latitude, end_station_longitude) %>%
#   rename(station_name = end_station_name, 
#          station_latitude = end_station_latitude, 
#          station_longitude = end_station_longitude) %>%
#   mutate(position = "end")
# 
# all_labels <- bind_rows(start_labels, end_labels) 
# 
# stations <- all_labels %>%
#   subset(!duplicated(station_name)) %>%
#   arrange(station_name)
# 
# 
# rm(all_labels, end_labels, start_labels)
# 
# 
# # #-------------------------------------------------
# # ## pivoted data
# # #-------------------------------------------------
# pivoted_data <- all_data %>%
#   pivot_longer(cols = c(start_station_latitude, end_station_latitude),
#                names_to = "lat_position",
#                values_to = "latitude") %>%
#   pivot_longer(cols = c(start_station_longitude, end_station_longitude),
#                names_to = "long_position",
#                values_to = "longitude") %>%
#   pivot_longer(cols = c(start_station_name, end_station_name),
#                names_to = "station_position",
#                values_to = "station_name") %>%
#   pivot_longer(cols = c(start_station_id, end_station_id),
#                names_to = "id_position",
#                values_to = "station_id") %>%
#   pivot_longer(cols = c(start_station_description, end_station_description),
#                names_to = "desc_position",
#                values_to = "station_desc")
