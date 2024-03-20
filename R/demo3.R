#' Run shiny app to set up core image analysis parameters
#'
#' @import shiny
#' @import DT
#' @importFrom shinyalert shinyalert
#' @return a data frame
#' @export
choose.data <- function(){
  runApp(
    shinyApp(
  
      ui <- fluidPage(
        h1("data tables and alerts"),
        checkboxInput("dt_sel", "select/deselect all", value = FALSE),
        DT::DTOutput("layerTable1"),
        actionButton('begin','Save Selections and Exit')
      ),
      server <- function(input, output, session) {
        
        output$layerTable1 <- DT::renderDT(iris)
        
        dt_proxy <- DT::dataTableProxy("layerTable1")
        
        observeEvent(input$dt_sel, {
          if (isTRUE(input$dt_sel)){
            DT::selectRows(dt_proxy, input$layerTable1_rows_all)
          } else {
            DT::selectRows(dt_proxy, NULL)
          }
        })
        
        observeEvent(input$begin, {
          if (length(input$layerTable1_rows_selected) < 1){
            shinyalert::shinyalert(title = "No Rows!", text = "Please choose at least 1 row to proceed")
          } else {
            stopApp(invisible(iris[input$layerTable1_rows_selected,]))
          }
        })
        
        
      }
    )
  )
}