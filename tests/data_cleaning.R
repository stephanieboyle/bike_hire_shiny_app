# Run from the repository root: Rscript tests/data_cleaning.R
script <- normalizePath("scripts/data_cleaning.R")
sandbox <- tempfile("bike-data-test-")
dir.create(sandbox)
original <- getwd()

run_checks <- function() {
  on.exit({setwd(original); unlink(sandbox, recursive = TRUE)}, add = TRUE)
  setwd(sandbox)
  dir.create("raw_data")
  journeys <- data.frame(
    started_at = c("2021-02-01 10:00:00", "2021-02-02 10:00:00"),
    ended_at = c("2021-02-01 11:00:00", "2021-02-02 10:30:00"),
    duration = c(3600, 1800),
    start_station_id = c(1, 2), start_station_name = c("West", "East"),
    start_station_description = c("West station", "East station"),
    start_station_latitude = c(55.9, 56.0),
    start_station_longitude = c(-3.3, -3.1),
    end_station_id = c(2, 1), end_station_name = c("East", "West"),
    end_station_description = c("East station", "West station"),
    end_station_latitude = c(56.0, 55.9),
    end_station_longitude = c(-3.1, -3.3)
  )
  write.csv(journeys, "raw_data/a.csv", row.names = FALSE)
  write.csv(journeys[1, ], "raw_data/overlap.csv", row.names = FALSE)
  writeLines("ignore this file", "raw_data/not-csv.txt")
  suppressPackageStartupMessages(source(script, local = new.env()))
  cleaned <- read.csv("clean_data/clean_data.csv")
  stations <- read.csv("clean_data/stations.csv")
  stopifnot(nrow(cleaned) == 2L,
            isTRUE(all.equal(cleaned$hours, c(1, 0.5))),
            isTRUE(all.equal(cleaned$mins, c(60, 30))),
            nrow(stations) == 2L,
            stations$longitude[stations$station_name == "West"] == -3.3,
            stations$latitude[stations$station_name == "East"] == 56.0)

  journeys$duration[1] <- -1
  write.csv(journeys, "raw_data/a.csv", row.names = FALSE)
  failure <- tryCatch({source(script, local = new.env()); NULL},
                      error = identity)
  stopifnot(inherits(failure, "error"),
            grepl("non-negative", conditionMessage(failure)))

  unlink(list.files("raw_data", full.names = TRUE))
  failure <- tryCatch({source(script, local = new.env()); NULL},
                      error = identity)
  stopifnot(inherits(failure, "error"),
            grepl("No CSV files", conditionMessage(failure)))
  message("Data preparation checks passed.")
}
run_checks()
