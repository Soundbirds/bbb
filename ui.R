library(shiny)
library(googleVis)
shinyUI(fluidPage(
  titlePanel("GoogleVis example"),
  sidebarLayout(
       sidebarPanel(
         h4("GoogleVis and Shiny")
         
       ),
    mainPanel(
      htmlOutput("bubble"),
      htmlOutput("scatter"),
      htmlOutput("guage")
    )
  ))
)
