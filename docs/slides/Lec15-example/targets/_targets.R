library(targets)

tar_option_set(
  packages = c("ggplot2", "GGally", "here")
)

list(
  # Figure 1: Run script that saves file directly
  tar_target(
    fig1_png,
    {
      source("fig1/fig.R")
      "fig1/fig.png"
    },
    format = "file"
  ),

  # Figure 2: Run script that returns ggplot object, then save it
  tar_target(
    fig2_plot,
    source("fig2/fig.R")$value
  ),

  tar_target(
    fig2_png,
    {
      path = "fig2/fig.png"
      ggsave(path, fig2_plot, width = 6, height = 4)
      path
    },
    format = "file"
  ),

  tar_target(
    paper_html,
    {
      c(fig1_png, fig2_png)  # Explicit dependency on figure files
      quarto::quarto_render("paper.qmd")
      "paper.html"
    },
    format = "file"
  )
)
