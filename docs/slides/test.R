library(plumber2)
library(httr2)

api = api() |>
  api_get(
    "/health", 
    function() {
      "ok"
    },
    serializers = get_serializers("json")
  )

server = api_run(api)

Sys.sleep(3)  # Wait for start

resp = request("http://127.0.0.1:8080/health") |>
  req_timeout(1) |>
  req_perform()

print(resp_body_json(resp))

api_stop(server)
