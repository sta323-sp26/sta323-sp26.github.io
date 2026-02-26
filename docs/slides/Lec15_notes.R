## Setup

set.seed(3212016)
d = data.frame(x = runif(250)) |>
  mutate(y = sin(2*pi*x) + rnorm(length(x)))

l = loess(y ~ x, data=d)
p = predict(l, se=TRUE)

d = d |> mutate(
  pred_y = p$fit,
  pred_y_se = p$se.fit
)

ggplot(d, aes(x,y)) +
  geom_point(color="gray50") +
  geom_ribbon(
    aes(ymin = pred_y - 1.96 * pred_y_se, 
        ymax = pred_y + 1.96 * pred_y_se), 
    fill="red", alpha=0.25
  ) +
  geom_line(aes(y=pred_y)) +
  theme_bw()

## Sequential implementation

n = 5e3

bs = purrr::map_dfr(
  seq_len(n),
  function(i) {
    d |>
      select(x, y) |>
      slice_sample(prop = 1, replace = TRUE) |>
      ( \(df) {
        mutate(
          df, iter = i,
          pred = loess(y ~ x, data = df) |> predict()
        )
      })()
  },
  .progress = TRUE
) |>
  group_by(x, y) |>
  summarize(
    bs_low = quantile(pred, probs = 0.025),
    bs_upp = quantile(pred, probs = 0.975),
    .groups = "drop"
  )

ggplot(d, aes(x,y)) +
  geom_point(color="gray50") +
  geom_ribbon(
    aes(ymin = pred_y - 1.96 * pred_y_se, 
        ymax = pred_y + 1.96 * pred_y_se), 
    fill="red", alpha=0.25
  ) +
  geom_line(aes(y=pred_y)) +
  theme_bw() +
  geom_ribbon(
    data = bs,
    aes(ymin = bs_low, ymax = bs_upp),
    color = "blue", alpha = 0.25
  )


## Parallel implementation


library(mirai)
daemons(10)

n = 5e4

bs_mc = map_dfr(
  seq_len(n),
  in_parallel(
    function(i) {
      d |>
        dplyr::select(x, y) |>
        dplyr::slice_sample(prop = 1, replace = TRUE) |>
        ( \(df) {
          dplyr::mutate(
            df, iter = i,
            pred = loess(y ~ x, data = df) |> predict()
          )
        })()
    },
    d = d
  ),
  .progress=TRUE
) |>
  group_by(x, y) |>
  summarize(
    bs_low = quantile(pred, probs = 0.025),
    bs_upp = quantile(pred, probs = 0.975),
    .groups = "drop"
  )


ggplot(d, aes(x,y)) +
  geom_point(color="gray50") +
  geom_ribbon(
    aes(ymin = pred_y - 1.96 * pred_y_se, 
        ymax = pred_y + 1.96 * pred_y_se), 
    fill="red", alpha=0.25
  ) +
  geom_line(aes(y=pred_y)) +
  theme_bw() +
  geom_ribbon(
    data = bs,
    aes(ymin = bs_low, ymax = bs_upp),
    color = "blue", alpha = 0.25
  ) +
  geom_ribbon(
    data = bs_mc,
    aes(ymin = bs_low, ymax = bs_upp),
    color = "green", alpha = 0.25
  )
