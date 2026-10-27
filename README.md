# Edinburgh Bike Hire Data Explorer

An R Shiny dashboard for exploring historical Just Eat Cycles journeys in Edinburgh.

## Project status

This is a historical data project. The original project recorded its last data refresh as February 2021; this maintenance pass fixes the preparation code, not the data's recency. It does not fetch live journeys.

The [original hosted app](https://stephanie-boyle.shinyapps.io/edinburgh_bike_hire_data_app/) may run a different revision. Repository changes do not redeploy it.

## Run locally

Install R, then clone this repository and open a terminal at its root (the folder containing `global.R`).

Install the packages used by the app:

```r
install.packages(c(
  "tidyverse", "lubridate", "leaflet", "shiny",
  "shinydashboard", "shinydashboardPlus", "scales", "DT"
))
```

Prepare the bundled historical CSV files before starting the app. The generated journey file is not included in the repository:

```sh
Rscript scripts/data_cleaning.R
```

Then, in R from the same directory:

```r
shiny::runApp(".")
```

Map tiles need an internet connection. The repaired app was tested with R 4.4.1; `renv.lock` records the tested package versions. To use that environment instead of installing the latest packages, run the following in R from the repository root, then prepare data and launch the app in that same R session:

```r
install.packages("renv")
renv::restore()
renv::load()
source("scripts/data_cleaning.R")
shiny::runApp(".")
```

## Data preparation

- Reads CSV files from `raw_data/` and removes identical journey rows across overlapping downloads.
- Checks required columns, timestamps and non-negative durations.
- Converts duration from seconds to minutes and hours.
- Keeps station names paired with their own coordinates. Where a station name has several locations, uses its first valid observed location.
- Writes `clean_data/clean_data.csv` and `clean_data/stations.csv`.

The historical downloads include identical files under different names. Removing identical rows prevents counting those journeys twice, although without a journey identifier truly distinct rides with identical fields cannot be distinguished.

Run the synthetic regression checks with:

```sh
Rscript tests/data_cleaning.R
```

The checks cover hour conversion, overlapping downloads, station coordinates, invalid durations and missing CSV files. They require `tidyverse` and `lubridate`.

After preparing the historical data, check the server outputs and date filtering with:

```sh
Rscript tests/server.R
```

If using the lockfile environment, run `source("tests/data_cleaning.R")` and `source("tests/server.R")` in the R session after `renv::load()` instead.

The bundled files produce 369,731 distinct journey rows, 171 stations and approximately 208,405 hours of cycling, covering 15 September 2018 to 26 February 2021. The server checks exercise journey and hours plots, station maps, total-hours consistency, a single-day selection and an empty date range. Browser checks also confirmed the introduction, overview charts and station charts/maps render with current package APIs.

## Explore the app

The Overview tab filters journeys by date. Breakdown and Station Overview summarise the whole prepared dataset.

## What's in the App?

The screenshots below are from the original 2021 version; their totals and map locations predate the data fixes.

The app contains four tabs: `introduction`, `overview`, `breakdown` and `stations`.


### Intro Tab

![](images/intro.png)

This contains an overview of the app, and shows all stations included in the data.

### Overview Tab

![](images/overview.png)

Here, you can choose the date range you wish to view, and can toggle between number of journeys/hours spent cycling.

### Breakdown Tab

![](images/breakdown.png)

On this tab, you can view the data by month or weekday. You can again choose between number of journeys taken and hours spent cycling. You also have the option to view a table of all data in the app.

### Stations Tab

![](images/stations.png)

On this final tab, you can see the top start and end stations, as well as their locations.


<br><br>


## Data Details


All code can be found on github: [https://github.com/stephanieboyle/bike_hire_shiny_app](https://github.com/stephanieboyle/bike_hire_shiny_app)

The data can be found here: [https://edinburghcyclehire.com/open-data](https://edinburghcyclehire.com/open-data)

The data dictionary for the variables is listed below:
![](images/data_dictionary.png)

<br>


Date: 22/03/2021
Author: [Stephanie Boyle](https://twitter.com/_stephanieboyle)
