library(tidyverse)
library(bslib)

stats = tibble(
  mean = 0.5,
  median = 0.45,
  q025 = 0.3,
  q975 = 0.7
)

cat("Names of stats:\n")
print(names(stats))

boxes = purrr::imap(
  stats,
  ~ value_box(
    title = stringr::str_to_title(.y),
    value = round(.x, 3)
  )
)

cat("\nClass of boxes:\n")
print(class(boxes))

cat("\nNames of boxes:\n")
print(names(boxes))

cat("\nLength of boxes:\n")
print(length(boxes))

cat("\nFirst element:\n")
print(boxes[[1]])
