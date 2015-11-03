library(shiny)
library(xtable)
ui <- fluidPage(
  titlePanel("Test"),
  sidebarPanel(
    withMathJax(sliderInput("x", label = "\\(x\\)-value",
                min = 0, max = 20, value = 2, step = 0.1))
  ),
  mainPanel(
    uiOutput("tab")
  )
)

server <- function (input, output) {
  
  output$tab <- renderUI(withMathJax(renderTable({
    tab <- matrix(input$x)
    colnames(tab) <- "\\(x\\)"
    tab
  }, include.rownames = F, sanitize.colnames.function = function(x) {x})))
  
}

shinyApp(ui = ui, server = server)