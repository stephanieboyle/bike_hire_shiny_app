library(tidyverse)
library(leaflet)
library(shiny)
library(shinydashboard)
library(lubridate)
library(shinydashboardPlus)
library(scales)
library(DT)

#-------------------------------------------------
# load in the data
#-------------------------------------------------

if (!file.exists("clean_data/clean_data.csv") ||
    !file.exists("clean_data/stations.csv")) {
  stop("Prepared data is missing. Run Rscript scripts/data_cleaning.R from the repository root first.")
}
clean_data <- read_csv("clean_data/clean_data.csv", show_col_types = FALSE)
stations <- read_csv("clean_data/stations.csv", show_col_types = FALSE)

#-------------------------------------------------
# source the files for plots
#-------------------------------------------------
source("scripts/stations.R")
source("scripts/maps.R")
source("scripts/breakdown.R")
#source()


