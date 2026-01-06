library(httr2)
library(tidyverse)

url = "http://127.0.0.1:8080"

test_data = request(url) |>
  req_url_path_append("data", "test") |>
  req_perform() |>
  resp_body_json() |>
  bind_rows()

pred = request(url) |>
  req_url_path_append("predict") |>
  req_body_json(test_data) |>
  req_perform() |>
  resp_body_json() |>
  bind_rows() |>
  mutate(
    species = as.factor(species),
    .pred_class = as.factor(.pred_class)
  )

yardstick::conf_mat(pred, truth = species, estimate = .pred_class)
