# Integration checks against the prepared historical data.
# Run from the repository root: Rscript tests/server.R
source("global.R")
source("server.R")

shiny::testServer(server, {
  session$setInputs(dateRange = range(clean_data$date),
                    metrics = "Number of journeys",
                    metrics_breakdown = "Number of journeys")
  stopifnot(nrow(reactive_data()) == nrow(clean_data),
            sum(total_journey_month()$total_count) == nrow(clean_data),
            isTRUE(all.equal(sum(total_hours()$total_hours), sum(clean_data$hours))))
  stopifnot(!is.null(output$totals_plot),
            !is.null(output$top_months),
            !is.null(output$top_weekday),
            !is.null(output$start_stations),
            !is.null(output$end_stations),
            !is.null(output$start_map),
            !is.null(output$end_map),
            !is.null(output$big_map),
            grepl(scales::comma(round(sum(clean_data$hours))), paste(unlist(output$total_hours_spent), collapse = ""),
                  fixed = TRUE))
  session$setInputs(metrics = "Hours spent cycling",
                    metrics_breakdown = "Hours spent cycling")
  stopifnot(!is.null(output$totals_plot), !is.null(output$top_months),
            !is.null(output$top_weekday))

  selected_date <- min(clean_data$date)
  session$setInputs(dateRange = rep(selected_date, 2))
  stopifnot(nrow(reactive_data()) == sum(clean_data$date == selected_date),
            all(reactive_data()$date == selected_date))

  session$setInputs(dateRange = as.Date(c("2000-01-01", "2000-01-02")))
  stopifnot(nrow(reactive_data()) == 0L)
  failure <- tryCatch({output$totals_plot; NULL}, error = identity)
  stopifnot(inherits(failure, "shiny.silent.error"),
            grepl("No journeys", conditionMessage(failure)))
})
message("Server integration checks passed.")
