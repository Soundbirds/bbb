library(shiny)
library(googleVis)
library(RCurl)
shinyServer(function(input, output, session){
  

    usStates <- read.csv(textConnection(getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")))
    usStates$date <- as.Date(usStates$date)
    usStates$newCases <- c(0, diff(usStates$cases))
    usStates$newDeaths <- c(0, diff(usStates$deaths))

  output$motion <- renderGvis({
    
    plot(gvisMotionChart(usStates[usStates$date > "2020-02-24", ], idvar = 'state', timevar = 'date', 
           xvar = 'deaths',  yvar = 'cases', sizevar = 'newCases', colorvar = 'newDeaths', options=list(width = 1024, height = 768)))
           
  })
  
})
