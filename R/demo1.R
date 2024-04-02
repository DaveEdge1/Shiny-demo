library(shiny)
ui <- fluidPage(
  shiny::h1("Hello, world!")
)
server <- function(input, output, session) {
}
shinyApp(ui, server)
