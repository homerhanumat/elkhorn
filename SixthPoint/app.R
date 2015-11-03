library(shiny)
library(shinythemes)
# 3225839205
ui <- fluidPage(
  titlePanel("Adding a Sixth Point"),
  theme = shinytheme("cerulean"),
  sidebarPanel(
    sliderInput("x", label = "x-coordinate of blue point",
                min = 0, max = 20, value = 2, step = 0.1),
    sliderInput("y", label = "y-coordinate of blue point",
                min = 0, max = 20, value = 1, step = 0.1),
    helpText("To see infromation about the slope of the regression line, ",
             "enter your password below!"),
    textInput("password","Password")
  ),
  mainPanel(
    plotOutput("scatter"),
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
    rv$sdx <- sd(xcurrent)
    rv$sdy <- sd(ycurrent)
    rv$zx <- (xcurrent- mean(xcurrent))/sd(xcurrent)
    rv$zy <- (ycurrent- mean(ycurrent))/sd(ycurrent)
    rv$mod <- lm(ycurrent ~ xcurrent)
  })
  
  output$scatter <- renderPlot({
    modcoeffs<- coefficients(rv$mod)
    plotTitle <- paste0("Red r = ",0, ", Red & Blue r = ",round(rv$corr, 2))
    if (!is.null(input$password) && input$password == "lovestats") {
      plotTitle <- paste0(plotTitle,"\nRed b = ",0,", Red & Blue b = ", 
                          round(modcoeffs[2],2))
    }
    plot(xold, yold, xlim = c(0,20), ylim = c(0,20), col = "red", pch = 19,
         main = plotTitle)
    points(rv$xblue, rv$yblue, col = "blue", cex = 2, pch = 19)
    abline(modcoeffs, lwd = 2)
    abline(4,0, lty = 2)
  }, height = 400, width = 500)
  
  output$tab <- renderTable({
    tab <- cbind(rv$xcurrent,rv$ycurrent,rv$sdx,rv$sdy,rv$zx,rv$zy,rv$zx*rv$zy)
    colnames(tab) <- c("x","y","sd(x)","sd(y)","z_x","z_y","z_x * z_y")
    round(tab,2)
  })
  
}

shinyApp(ui = ui, server = server)