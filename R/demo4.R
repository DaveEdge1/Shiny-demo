#' Run shiny app to set up core image analysis parameters
#'
#' @import shiny
#' @import DT
#' @import shinyFiles
#' @importFrom shinyalert shinyalert
#' @return a data frame
#' @export
choose.data3 <- function(){
  runApp(
    shinyApp(

      ui <- fluidPage(
        h1("data tables and alerts"),
        checkboxInput("dt_sel", "select/deselect all", value = FALSE),
        #shinyFiles::shinyFilesButton("df_file", "Select data frame csv file", title = "Select data frame",multiple = FALSE),
        fileInput("df_file", NULL, buttonLabel = "Select data frame csv file", multiple = FALSE,accept = "csv"),
        DT::DTOutput("layerTable1"),
        actionButton('begin','Save Selections and Exit')
      ),
      server <- function(input, output, session) {
        #volumes <- c(shinyFiles::getVolumes()())

        values <- reactiveValues(df_data = NULL)

        dt_proxy <- DT::dataTableProxy("layerTable1")

        observeEvent(input$df_file, {
          values$df_data <- read.csv(input$df_file$datapath)
        })

        output$layerTable1 <- DT::renderDT(values$df_data, selection = list(target = "column"), height = 100, server = FALSE)

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
