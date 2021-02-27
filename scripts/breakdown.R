
#-----------------------------------------------------
# breakdown
#-----------------------------------------------------
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


# most popular day of the week time spent
weekday_hours <- clean_data %>%
  group_by(weekday,weekday_label) %>%
  summarise(pop_mins = sum(mins), 
            pop_hours = pop_mins/60)

# most popular day of the week count
weekday_pop <- clean_data %>%
  group_by(weekday,weekday_label) %>%
  summarise(pop = n())
