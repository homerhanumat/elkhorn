library(shiny)
library(shinythemes)
# 3225839205
ui <- fluidPage(
  titlePanel("Adding a Sixth Point"),
  theme = shinytheme("cerulean"),
  sidebarPanel(
    withMathJax(sliderInput("x", label = "\\(x\\)-coordinate of blue point",
                min = 0, max = 20, value = 2, step = 0.1)),
    sliderInput("y", label = "\\(y\\)-coordinate of blue point",
                min = 0, max = 20, value = 1, step = 0.1),
    checkboxInput(inputId = "standard", "Graph with standardized coordinates",
                  value = FALSE),
    helpText("To see information about the slope \\(b\\) of the regression line, ",
             "enter your password below!"),
    textInput("password","Password")
  ),
  mainPanel(
    plotOutput("scatter"),
    br(),
    tableOutput("tab")
  )
)

server <- function (input, output) {
  
  xold <- c(1,1,2,3,3)
  yold <- c(3,5,4,3,5)
  sd_x_old <- sd(xold)
  sd_y_old <- sd(yold)
  z_x_old <- (xold - mean(xold))/sd_x_old
  z_y_old <- (yold - mean(yold))/sd_y_old
  
  rv <- reactiveValues(
    xblue = NULL,
    yBlue = NULL,
    xcurrent = NULL,
    ycurrent = NULL,
    corr = NULL,
    sdx = NULL,
    sdy = NULL,
    zx = NULL,
    zy = NULL,
    mod = NULL
  )
  
  observe({
    xcurrent <- c(xold, input$x)
    ycurrent <- c(yold, input$y)
    rv$xcurrent <- xcurrent
    rv$ycurrent <- ycurrent
    rv$xblue <- input$x
    rv$yblue <- input$y
    rv$corr <- cor(xcurrent, ycurrent)
    rv$meanx <- mean(xcurrent)
    rv$meany <- mean(ycurrent)
    rv$sdx <- sd(xcurrent)
    rv$sdy <- sd(ycurrent)
    zx <- (xcurrent- mean(xcurrent))/sd(xcurrent)
    rv$zx <- zx
    zy <- (ycurrent- mean(ycurrent))/sd(ycurrent)
    rv$zy <- zy
    rv$mod <- lm(ycurrent ~ xcurrent)
    rv$modStand <- lm(zy ~ zx)
  })
  
  output$scatter <- renderPlot({
    modcoeffs<- coefficients(rv$mod)
    modcoeffsStand <- coefficients(rv$modStand)
    print(input$standard)
    plotTitle <- paste0("Red r = ",0, ", Red & Blue r = ",round(rv$corr, 2))
    if (!is.null(input$password) && input$password == "lovestats") {
      plotTitle <- paste0(plotTitle,"\nRed b = ",0,", Red & Blue b = ", 
                          round(modcoeffs[2],2))
    }
    if (input$standard == FALSE) {
    plot(xold, yold, xlim = c(0,20), ylim = c(0,20), col = "red", pch = 19,
         main = plotTitle, xlab = "x", ylab = "y")
    points(rv$xblue, rv$yblue, col = "blue", cex = 2, pch = 19)
    abline(modcoeffs, lwd = 2)
    abline(4,0, lty = 2)
    } else {
      xmin <- min(rv$zx); xmax <- max(rv$zx); ymin <- min(rv$zy); ymax <- max(rv$zy)
      plot(rv$zx[1:5], rv$zy[1:5], xlim = c(xmin,xmax), 
           ylim = c(ymin,ymax), col = "red", pch = 19,
           main = plotTitle, xlab = "z_x", ylab = "z_y", 
           sub = "Using standardized coordinates!\n(Showing only R + B regression line.)")
      points(rv$zx[6], rv$zy[6], col = "blue", cex = 2, pch = 19)
      abline(modcoeffsStand, lwd = 2)
      abline(h = 0, lty = 2)
      abline(v = 0, lty = 2)
    }
  }, height = 400, width = 500)
  
#   output$tab <- renderUI(withMathJax(renderTable({
#     tab <- cbind(rv$xcurrent,rv$ycurrent,rv$sdx,rv$sdy,rv$zx,rv$zy,rv$zx*rv$zy)
#     colnames(tab) <- c("\\(x\\)","\\(y\\)","\\(s_x\\)",
#                        "\\(s_y\\)","\\(z_x\\)","\\(z_y\\)","\\(z_xz_y\\)")
#     round(tab,2)
#   }, include.rownames = F)))
  
  output$tab <- renderTable({
    tab <- cbind(rv$xcurrent,rv$meanx,rv$sdx,rv$zx,
                 rv$ycurrent,rv$meany,rv$sdy,rv$zy,rv$zx*rv$zy)
    colnames(tab) <- c("x","mean_x","s_x","z_x","y","mean_y","s_y",
                       "z_y","z_x * z_y")
    round(tab,2)
  }, include.rownames = F)
  
}

shinyApp(ui = ui, server = server)