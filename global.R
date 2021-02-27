library(tidyverse)
library(leaflet)
library(shinyWidgets)
library(shiny)
library(shinydashboard)
library(lubridate)
library(shinythemes)
library(dashboardthemes)
library(shinydashboardPlus)
library(scales)

#-------------------------------------------------
# load in the data
#-------------------------------------------------
source("scripts/data_cleaning.R")

source("scripts/data_cleaning.R")

clean_data <- read_csv("clean_data/clean_data.csv")
stations <- read_csv("clean_data/stations.csv")
