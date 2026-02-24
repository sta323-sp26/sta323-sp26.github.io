library(tidyverse)
library(httr2)

## Demo 1 - GitHub API - Basic access

z = jsonlite::read_json("https://api.github.com/orgs/sta323-sp26/repos")
length(z)
str(z, max.level = 2)
z |> map_chr("full_name")

z = jsonlite::read_json("https://api.github.com/orgs/tidyverse/repos")
length(z)
z |> map_chr("full_name")

z = jsonlite::read_json("https://api.github.com/orgs/tidyverse/repos?page=2")
length(z)
z |> map_chr("full_name")

z = jsonlite::read_json("https://api.github.com/orgs/tidyverse/repos?per_page=100")
length(z)
z |> map_chr("full_name")


## Demo 2 - Authenticated Endpoint(s)

jsonlite::read_json("https://api.github.com/user")


## Demo 3 - httr2 + GitHub

### Basic request

resp = request("https://api.github.com/users/rundel") |>
  req_perform()

resp |> resp_status()
resp |> resp_status_desc()
resp |> resp_content_type()

resp |> resp_body_json() |> str()


### Pagination

request("https://api.github.com/orgs/tidyverse/repos") |>
  req_auth_bearer_token(gitcreds::gitcreds_get()$password) |>
  req_perform() |>
  resp_body_json() |>
  map_chr("full_name")

request("https://api.github.com/orgs/tidyverse/repos") |>
  req_url_query(page=2) |>
  req_perform() |>
  resp_body_json() |>
  map_chr("full_name")

request("https://api.github.com/orgs/tidyverse/repos") |>
  req_url_query(per_page=100) |>
  req_perform() |>
  resp_body_json() |>
  map_chr("full_name")

resps = request("https://api.github.com/orgs/tidyverse/repos") |>
  req_url_query(per_page=15) |>
  req_perform_iterative(next_req = iterate_with_link_url())

resps

resps |>
  map(resp_body_json) |>
  purrr::list_flatten() |>
  map_chr("full_name")


### Error handling

request("https://api.github.com/user") |>
  req_perform()

resp = request("https://api.github.com/user") |>
  req_error(is_error = function(resp) FALSE) |>
  req_perform()

resp |> resp_status()
resp |> resp_status_desc()
resp |> resp_body_json() |> str()


## Demo 4 - Using Authentication

request("https://api.github.com/user") |>
  req_auth_bearer_token(gitcreds::gitcreds_get()$password) |>
  req_perform() |>
  resp_body_json() |>
  str()

request("https://api.github.com/user") |>
  req_headers(
    Authorization = paste("Bearer", gitcreds::gitcreds_get()$password)
  ) |>
  req_perform() |>
  resp_body_json() |>
  str()


## Demo 5 - POST Request

gist = request("https://api.github.com/gists") |>
  req_auth_bearer_token(gitcreds::gitcreds_get()$password) |>
  req_body_json(list(
    description = "Testing 1 2 3 ...",
    files = list("test.R" = list(content = "print('hello world')\n")),
    public = TRUE
  ))

gist |> req_dry_run()

resp = gist |> req_perform()
resp |> resp_status()
resp |> resp_status_desc()
resp |> resp_body_json() |> pluck("html_url")
