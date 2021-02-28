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

clean_data <- read_csv("clean_data/clean_data.csv")
stations <- read_csv("clean_data/stations.csv")

#-------------------------------------------------
# source the files for plots
#-------------------------------------------------
source("scripts/stations.R")
source("scripts/maps.R")
source("scripts/breakdown.R")
#source()


