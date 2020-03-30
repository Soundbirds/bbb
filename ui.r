library(shiny)
library(googleVis)
shinyUI(fluidPage(
  titlePanel("Data visualization of the NY Times COVID-19 data"),
  sidebarLayout(
       sidebarPanel(
         h4("Data visualization of the NY Times COVID-19 data")
         
       ),
    mainPanel(
      htmlOutput("motion")
    )
  ))
)