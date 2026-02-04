library(fs)
library(curl)
library(tidyverse)

if (!file_exists("data/BFStr_Netz_v2025q3.gpkg")) {
  curl_download("https://www.bast.de/SharedDocs/Daten-TB/Daten-BISStra.zip?__blob=publicationFile&v=5", destfile = "data/", quiet = FALSE)
  unzip("data/Daten-BISStra.zip", exdir = "data")
}

