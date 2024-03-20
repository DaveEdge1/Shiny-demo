#' Run shiny app to set up core image analysis parameters
#'
#' @import shiny
#' @import DT
#' @import shinyFiles
#' @importFrom shinyalert shinyalert
#' @return a data frame
#' @export
choose.data <- function(){
  runApp(
    shinyApp(
  
      ui <- fluidPage(
        h1("data tables and alerts"),
        checkboxInput("dt_sel", "select/deselect all", value = FALSE),
        shinyFiles::shinyFilesButton("df_file", "Select data frame csv file", title = "Select data frame",multiple = FALSE),
        DT::DTOutput("layerTable1"),
        actionButton('begin','Save Selections and Exit')
      ),
      server <- function(input, output, session) {
        volumes <- c(shinyFiles::getVolumes()())
        
        output$layerTable1 <- DT::renderDT(iris)
        
        dt_proxy <- DT::dataTableProxy("layerTable1")
        
        observeEvent(input$chooseDF, {
          shinyFiles::shinyFileChoose(input, "df_file", roots = volumes)
          output$layerTable1 <- DT::renderDT(input$df_file)
          dt_proxy <- DT::dataTableProxy("df_file")
        })
        
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