library(tidyverse)
library(lubridate)


# File for data
datafile <- "data/data.Rdata"


# -------------------------------------------------------------------------------------------------
# Helper functions
# -------------------------------------------------------------------------------------------------

# Download one file
download_one_file <- function(filename) {
  url <- str_glue(
    "https://www.opengeodata.nrw.de/produkte/transport_verkehr/unfallatlas/{filename}"
  )
  download.file(url, destfile = str_glue("data/{filename}"))
}

# Download CSV and Shapefile
download_files <- function(year) {
  download_one_file(str_glue("Unfallorte{year}_EPSG25832_CSV.zip"))
  download_one_file(str_glue("Unfallorte{year}_EPSG25832_Shape.zip"))
}

# Read CSV from zipfile
read_one_csv_file <- function(filename) {
  content <- unzip(filename, list = TRUE)
  path <- content |> filter(str_detect(Name, "LinRef")) |> pluck("Name")
  read_csv2(unzip(filename, path))
}


# -------------------------------------------------------------------------------------------------
# Download, read and process data if needed, otherwise, just load data
# -------------------------------------------------------------------------------------------------

if (!file.exists(datafile)) {
  # Download files, comment out during development :-)
  2016:2023 |> walk(download_files)
  
  # Read CSV files and prepare data
  d_unfaelle <- list.files(path = "data",
                           pattern = ".*CSV.zip",
                           full.names = TRUE) |>
    map(read_one_csv_file) |>
    bind_rows() |>
    mutate(
      UWOCHENTAG = wday(UWOCHENTAG, label = TRUE, locale = "de_DE"),
      ULICHTVERH = factor(
        ULICHTVERH,
        levels = 0:2,
        labels = c("Tageslicht", "Dämmerung", "Dunkelheit"),
        ordered = TRUE
      )
    )
  
  save(d_unfaelle, file = datafile)
} else {
  load(file = datafile)
}
