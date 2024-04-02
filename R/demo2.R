#' Run shiny app to set up core image analysis parameters
#'
#' @import shiny
#' @export
simple.demo <- function(){
  runApp(
    shinyApp(

      ui <- fluidPage(
        shiny::h1("Hello, world!")
      ),
      server <- function(input, output, session) {
      }
    ),
    launch.browser = TRUE
  )
}
