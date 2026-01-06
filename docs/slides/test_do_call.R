library(tidyverse)
library(bslib)

stats = tibble(
  mean = 0.5,
  median = 0.45,
  q025 = 0.3,
  q975 = 0.7
)

boxes = purrr::imap(
  stats,
  ~ value_box(
    title = stringr::str_to_title(.y),
    value = round(.x, 3)
  )
)

cat("Names before unname:\n")
print(names(boxes))

# Test 1: With names
cat("\n\nTest 1: do.call with named list\n")
result1 = do.call(layout_column_wrap, c(list(width = "200px"), boxes))
print(result1)

# Test 2: Without names
cat("\n\nTest 2: do.call with unnamed list\n")
boxes_unnamed = unname(boxes)
result2 = do.call(layout_column_wrap, c(list(width = "200px"), boxes_unnamed))
print(result2)
