library(tidyverse)
library(lubridate)

# Run from the repository root: Rscript scripts/data_cleaning.R
files <- list.files("raw_data", pattern = "\\.csv$", full.names = TRUE)
if (length(files) == 0L) {
  stop("No CSV files found in raw_data/. Run from the repository root.")
}

# Some historical downloads overlap. Count each identical journey row once.
all_data <- lapply(files, read_csv, show_col_types = FALSE) %>%
  bind_rows() %>%
  distinct()

required <- c(
  "started_at", "ended_at", "duration",
  "start_station_id", "start_station_name", "start_station_description",
  "start_station_latitude", "start_station_longitude",
  "end_station_id", "end_station_name", "end_station_description",
  "end_station_latitude", "end_station_longitude"
)
missing <- setdiff(required, names(all_data))
if (length(missing) > 0L) {
  stop("Missing journey columns: ", paste(missing, collapse = ", "))
}
if (nrow(all_data) == 0L) stop("The journey CSV files contain no rows.")
if (!is.numeric(all_data$duration) ||
    any(!is.finite(all_data$duration) | all_data$duration < 0)) {
  stop("Journey durations must be finite, non-negative seconds.")
}
if (!inherits(all_data$started_at, "POSIXt") ||
    !inherits(all_data$ended_at, "POSIXt") ||
    anyNA(all_data$started_at) || anyNA(all_data$ended_at)) {
  stop("Journey timestamps must be valid date-times.")
}

clean_data <- all_data %>%
  mutate(year = year(started_at),
         month = month(started_at),
         month_label = month(started_at, label = TRUE, abbr = TRUE),
         day = day(started_at),
         date = as.Date(started_at),
         weekday = wday(started_at),
         weekday_label = wday(started_at, label = TRUE),
         mins = duration / 60,
         hours = duration / 3600,
         seconds = duration) %>%
  select(year, month, month_label, date, day, weekday, weekday_label,
         mins, hours, seconds, all_of(setdiff(required, "duration"))) %>%
  arrange(date)

# Keep each station's own coordinates together rather than cross-joining
# start/end names, latitudes and longitudes.
stations <- bind_rows(
  clean_data %>% transmute(station_name = start_station_name,
                           longitude = start_station_longitude,
                           latitude = start_station_latitude),
  clean_data %>% transmute(station_name = end_station_name,
                           longitude = end_station_longitude,
                           latitude = end_station_latitude)
) %>%
  filter(!is.na(station_name), is.finite(longitude), is.finite(latitude)) %>%
  distinct(station_name, .keep_all = TRUE)

dir.create("clean_data", showWarnings = FALSE, recursive = TRUE)
write_csv(clean_data, "clean_data/clean_data.csv")
write_csv(stations, "clean_data/stations.csv")
message("Prepared ", nrow(clean_data), " journeys and ", nrow(stations), " stations.")
