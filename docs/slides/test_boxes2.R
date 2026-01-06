library(tidyverse)
library(bslib)

# Simulate the stats dataframe EXACTLY as in the app
stats = tibble(
  mean = 0.5,
  median = 0.45,
  q025 = 0.3,
  q975 = 0.7
)

print("Stats structure:")
print(str(stats))

print("\nIteration test with purrr::map2:")
boxes = purrr::map2(
  stats, names(stats),
  function(x, y) {
    cat("Processing:", y, "=", x, "\n")
    cat("Class of x:", class(x), "\n")
    cat("Length of x:", length(x), "\n\n")
    value_box(
      title = stringr::str_to_title(y),
      value = round(x, 3)
    )
  }
)

print("\nNumber of boxes created:")
print(length(boxes))
