library(tidyverse)
library(bslib)

# Simulate the stats dataframe
stats = tibble(
  mean = 0.5,
  median = 0.45,
  q025 = 0.3,
  q975 = 0.7
)

# Try the purrr::map2 approach
boxes = purrr::map2(
  stats, names(stats),
  ~ value_box(
    title = stringr::str_to_title(.y),
    value = round(.x, 3)
  )
)

# Check what we get
print("Number of boxes:")
print(length(boxes))

print("\nClass of boxes:")
print(class(boxes))

print("\nFirst box:")
print(boxes[[1]])

# Try the layout
result = do.call(
  layout_column_wrap,
  c(list(width = "200px"), boxes)
)

print("\nResult class:")
print(class(result))
