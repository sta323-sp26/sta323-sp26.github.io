library(tidyverse)
library(nycflights13)
library(palmerpenguins)

# Example 1

# How many flights to LAX did each legacy carrier (AA, UA, DL, US)
# have in May from JFK, and what was their average duration?

flights |>
  filter(dest == "LAX", carrier %in% c("AA", "UA", "DL", "US"), month == 5, origin == "JFK") |>
  summarize(
    n_flights = n(),
    avg_duration = mean(air_time, na.rm = TRUE),
    .by = carrier
  )


# What was the shortest flight out of each airport in terms of
# distance?

flights |>
  slice_min(distance, by = origin)


# Which plane (tail number) flew out of each New York airport the most?

flights |>
  count(origin, tailnum) |>
  slice_max(n, by = origin)


# Which date should you fly on if you want to have the lowest
# possible average departure delay? What about arrival delay?

flights |>
  group_by(month, day) |>
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    .groups = "drop"
  ) |>
  slice_min(avg_dep_delay, n = 5)



# Exercise 1: Palmer penguins contingency table

palmerpenguins::penguins |>
  count(island, species) |>
  pivot_wider(
    names_from = species,
    values_from = n,
    values_fill = 0
  )


# Example 2: Tidy grades

grades = tibble::tribble(
  ~name,   ~hw_1, ~hw_2, ~hw_3, ~hw_4, ~proj_1, ~proj_2,
  "Alice",    19,    19,    18,    20,      89,      95,
  "Bob",      18,    20,    18,    16,      77,      88,
  "Carol",    18,    20,    18,    17,      96,      99,
  "Dave",     19,    19,    18,    19,      86,      82
)

final_grades = grades |>
  tidyr::pivot_longer(
    cols = hw_1:proj_2,
    names_to = c("type", "id"),
    names_sep = "_",
    values_to = "score"
  ) |>
  summarize(
    total = sum(score),
    .by = c(name, type)
  ) |>
  tidyr::pivot_wider(
    names_from = type,
    values_from = total
  ) |>
  mutate(
    score = 0.5*(hw/80) + 0.5*(proj/200)
  )

final_grades
