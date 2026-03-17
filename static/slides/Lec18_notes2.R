library(tidyverse)
library(shiny)
library(bslib)

palette = c(
  Green = "#7fc97f", Purple = "#beaed4", Orange = "#dfc086",
  Yellow = "#ffff99", Blue = "#386cb0", Pink = "#f0027f"
)



ui = page_sidebar(
  title = "Beta-Binomial Visualizer",
  sidebar = sidebar(
    h4("Data:"),
    sliderInput("x", "# of heads", min=0, max=100, value=7),
    sliderInput("n", "# of flips", min=0, max=100, value=10),
    h4("Prior:"),
    numericInput("alpha", "Prior # of head", min=0, value=5),
    numericInput("beta", "Prior # of tails", min=0, value=5),
    checkboxInput("options", "Show Options", value = FALSE),
    conditionalPanel(
      "input.options == true",
      checkboxInput("bw", "Use theme_bw", value = FALSE),
      checkboxInput("facet", "Use facets", value = FALSE),
      
      selectInput("prior", "Color for prior", choices = names(palette), selected = names(palette)[1]),
      selectInput("likelihood", "Color for likelihood", choices = names(palette), selected = names(palette)[2]),
      selectInput("posterior", "Color for posterior", choices = names(palette), selected = names(palette)[3])
    )
  ),
  plotOutput("plot"),
  tableOutput("table") 
)

server = function(input, output, session) {
  
  observe({
    choices = c(prior = input$prior, likelihood = input$likelihood, posterior = input$posterior)
    iwalk(
      choices,
      function(color, dist) {
        to_remove = setdiff(choices, color)
        updateSelectInput(
          session, dist,
          choices  = setdiff(names(palette), to_remove),
          selected = color
        )
      }
    )
  })

  observe({
    updateSliderInput(session, "x", max = input$n)
  }) |>
    bindEvent(input$n)
  
  d = reactive({
    tibble(
      p = seq(0, 1, length.out = 1000)
    ) |>
    mutate(
      prior = dbeta(p, input$alpha, input$beta),
      likelihood = dbinom(input$x, size = input$n, prob = p) |> 
        (\(x) {x / (sum(x) / n())})(),
      posterior = dbeta(p, input$alpha + input$x, input$beta + input$n - input$x)
    ) |>
    pivot_longer(
      cols = -p,
      names_to = "distribution",
      values_to = "density"
    ) |>
    mutate(
      distribution = forcats::as_factor(distribution)
    )
  })
  
  output$plot = renderPlot({
    choices = c(input$prior, input$likelihood, input$posterior)
    color_pal = palette[choices] |> 
      unname()
    
    g = ggplot(d(), aes(x=p, y=density, color=distribution)) +
    geom_line(size=1.5) +
    geom_ribbon(aes(ymax=density, fill=distribution), ymin=0, alpha=0.5) +
    scale_color_manual(values = color_pal) +
    scale_fill_manual(values = color_pal)
    
    if (input$bw)
    g = g + theme_bw()
    
    if (input$facet) 
    g = g + facet_wrap(~distribution)
    
    g
  })
  
  output$table = renderTable({
    d() |>
    group_by(distribution) |>
    summarize(
      mean = sum(p * density) / n(),
      median = p[(cumsum(density/n()) >= 0.5)][1],
      q025 = p[(cumsum(density/n()) >= 0.025)][1],
      q975 = p[(cumsum(density/n()) >= 0.975)][1]
    )
  })
}

shinyApp(ui = ui, server = server)