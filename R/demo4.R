#' upload data, plot, and save
#'
#' @import shiny
#' @import DT
#' @import ggplot2
#' @import shinyFiles
#' @importFrom shinyalert shinyalert
#' @importFrom tools file_ext
#' @return a data frame
#' @export
choose.data3 <- function(){
  runApp(
    shinyApp(

      ui <- fluidPage(
        sidebarLayout(
          sidebarPanel(
            textInput("imageName","Provide a file name for your plot image"),
            sliderInput("width", "Image width in pixels", value = 300, min = 100, max = 10000),
            sliderInput("height", "Image height in pixels", value = 200, min = 100, max = 10000),
            actionButton("save", "Choose directory for saved plot")
          ),
          mainPanel(
            h1("uploading data for reactive plots"),
            h3("choose your data (csv)"),
            fileInput("df_file", NULL, buttonLabel = "Select data frame csv file", multiple = FALSE,accept = "csv"),
            h3("choose two columns to plot"),
            DT::DTOutput("layerTable1"),
            plotOutput("plot1")
          )
        )
      ),
      server <- function(input, output, session) {

        values <- reactiveValues(df_data = NULL)

        sub_values <- reactiveValues(df_data = NULL)

        dt_proxy <- DT::dataTableProxy("layerTable1")

        observeEvent(input$df_file, {
          values$df_data <- read.csv(input$df_file$datapath)
        })

        output$layerTable1 <- DT::renderDT(values$df_data, selection = list(target = "column"), height = 100, server = FALSE)

        observeEvent(input$layerTable1_columns_selected, {
          sub_values$df_data <- values$df_data[,input$layerTable1_columns_selected]
        })

        height1 <- reactive(input$height)
        width1 <- reactive(input$width)


        output$plot1 <- renderPlot({
          if (is.null(sub_values$df_data) || length(sub_values$df_data) < 1){
            ""
          } else {
            if (is.null(ncol(sub_values$df_data))){
              ""
            } else {
              if (ncol(sub_values$df_data) != 2){
                ""
              } else {
                tryCatch(
                  {
                    ggplot(data=sub_values$df_data, mapping = aes_string(x=names(sub_values$df_data)[1],y=names(sub_values$df_data)[2])) +
                      geom_point() +
                      geom_smooth(method='lm', formula= y~x)
                  },
                  error=function(cond) {
                    ""
                  },
                  warning = function(cond) {
                    ""
                  }
                )
              }
            }
          }
        },
        height = height1,
        width=width1
        )

        observeEvent(input$save, {

          if (nchar(tools::file_ext(input$imageName))<=1){
            message("provided file name lacks a proper extnsion, using '.png'")
            message(tools::file_ext(input$imageName))
            name1 <- "Shiny-demo_plot.png"
          } else {
            name1 <- input$imageName
          }
          message(paste0("name1: ",name1))

          path1 <- file.path(choose.dir(),name1)
          ggsave(path1,device = "png",width = input$width,height=input$height,limitsize = FALSE,units = "px")
          stopApp(paste0("Plot image saved at: ", path1))
        })
      }
    )
  )
}
