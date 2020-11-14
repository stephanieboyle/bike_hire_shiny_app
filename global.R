library(tidyverse)
library(leaflet)
library(shinyWidgets)
library(shiny)
library(shinydashboard)
library(lubridate)
library(shinythemes)
library(dashboardthemes)
library(shinydashboardPlus)

#-------------------------------------------------
# load in the data
#-------------------------------------------------
source("scripts/data_analysis.R")

clean_data <- read_csv("clean_data/clean_data.csv")
start_stations <- read_csv("clean_data/stations.csv")