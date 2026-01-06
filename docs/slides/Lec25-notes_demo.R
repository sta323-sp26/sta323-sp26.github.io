library(tidyverse)
library(tidymodels)

penguins = palmerpenguins::penguins |>
  select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex) |>
  drop_na()
  
set.seed(123)
penguin_split = initial_split(penguins, prop = 0.8, strata = species)
penguin_train = training(penguin_split)
penguin_test = testing(penguin_split)

penguin_recipe = recipe(species ~ ., data = penguin_train) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors())

penguin_model = multinom_reg() |>
  set_engine("nnet") |>
  set_mode("classification")

penguin_wf = workflow() |>
  add_recipe(penguin_recipe) |>
  add_model(penguin_model)

penguin_fit = fit(penguin_wf, data = penguin_train)

#* Return model summary as text
#* @get /model
#* @serializer text
function() {
  out = capture.output(print(penguin_fit))
  paste(out, collapse = "\n")
}

#* Return model tidy
#* @get /model/tidy
function() {
  tidy(penguin_fit)
}

#* Return model glance
#* @get /model/glance
function() {
  glance(penguin_fit)
}

#* Predict penguin species (single)
#* @query bill_length_mm:number Bill length in mm
#* @query bill_depth_mm:number Bill depth in mm
#* @query flipper_length_mm:number Flipper length in mm
#* @query body_mass_g:number Body mass in grams
#* @query sex:string Sex (male/female)
#* @get /predict
function(query) {
  new_data = tibble(
    bill_length_mm = query$bill_length_mm %||% 0,
    bill_depth_mm = query$bill_depth_mm %||% 0,
    flipper_length_mm = query$flipper_length_mm  %||% 0,
    body_mass_g = query$body_mass_g %||% 0,
    sex = factor(query$sex %||% "female", levels = c("female", "male"))
  )

  augment(penguin_fit, new_data)
}

#* Predict penguin species (batch)
#* @post /predict
#* @parser json
function(body) {
  new_data = body |>
    as_tibble() |>
    mutate(
      bill_length_mm = as.numeric(bill_length_mm),
      bill_depth_mm = as.numeric(bill_depth_mm),
      flipper_length_mm = as.numeric(flipper_length_mm),
      body_mass_g = as.numeric(body_mass_g),
      sex = factor(sex, levels = c("female", "male"))
    )

  augment(penguin_fit, new_data)
}


#* Get training data
#* @get /data/train
function() {
  penguin_train
}

#* Get testing data
#* @get /data/test
function() {
  penguin_test
}

#* Scatter plot of training data
#* @param x:string Variable for x-axis
#* @param y:string Variable for y-axis
#* @get /plot/<x>/<y>
#* @serializer png
function(x, y) {
  penguin_train |>
    ggplot(
      aes(x = .data[[x]], y = .data[[y]], color = species)
    ) +
    geom_point() +
    theme_minimal()
}

