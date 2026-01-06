library(shiny)
library(bslib)
library(purrr)

ui = page_fluid(
  card(
    card_header("Test"),
    card_body(uiOutput("test"))
  )
)

server = function(input, output, session) {
  output$test = renderUI({
    stats = data.frame(
      mean = 0.5,
      median = 0.45
    )

    # Method 1: Explicit
    cat("Testing explicit method\n")
    result1 = layout_column_wrap(
      width = "200px",
      value_box(title = "Mean", value = stats$mean),
      value_box(title = "Median", value = stats$median)
    )

    return(result1)
  })
}

shinyApp(ui = ui, server = server)
