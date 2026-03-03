library(rvest)
library(tidyverse)
library(jsonlite)

## get_lq.R example

url = "https://www.wyndhamhotels.com/laquinta/locations"

x = read_html(url) |>
  html_elements(".property a:nth-child(1)") |>
  html_attr("href") |>
  (\(x) fs::path(dirname(dirname(url)), x))()

x[1]

dir.create("data/lq", showWarnings = FALSE, recursive = TRUE)

out = fs::path(
  "data/lq/",
  paste0(basename(dirname(x[1])), ".html")
)

message("Downloading ", out)
download.file(x[1], out, quiet=TRUE)


## Dennys location API

library(httr2)

request("https://www.dennys.com/restaurants/near") |>
  req_url_query(
    lat = 35.779557,
    long = -78.638148,
    radius = 10,
    limit = 10,
    nomnom = "calendars",
    nomnom_calendars_from = "20251007",
    nomnom_calendars_to = "20251015",
    nomnom_exclude_extref = 999
  ) |>
  req_perform() |>
  resp_body_json() |>
  str()


## get_dennys.R example

url = "https://locations.dennys.com/"

p = read_html(url)

states = p |> 
  html_elements("#states-container a") |>
  html_attr("href")


states[1] |>
  read_html() |>
  html_elements(".col-lg-3 a") |>
  html_attr("href")
    