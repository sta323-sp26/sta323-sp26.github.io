library(shiny)
library(bslib)

ui = page_fluid(
  card(
    card_header("Test Value Boxes"),
    card_body(
      uiOutput("boxes_output")
    )
  )
)

server = function(input, output, session) {
  output$boxes_output = renderUI({
    stats = data.frame(
      mean = 0.5,
      median = 0.45,
      q025 = 0.3,
      q975 = 0.7
    )

    boxes = purrr::map2(
      stats, names(stats),
      ~ value_box(
        title = stringr::str_to_title(.y),
        value = round(.x, 3)
      )
    )

    do.call(
      layout_column_wrap,
      c(list(width = "200px"), boxes)
    )
  })
}

shinyApp(ui = ui, server = server)
