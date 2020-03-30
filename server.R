library(shiny)
library(googleVis)
shinyServer(function(input, output, session){
  



  output$bubble <- renderGvis({
    
    gvisBubbleChart(Fruits, idvar="Fruit", 
                    xvar="Sales", yvar="Expenses",
                    colorvar="Year", sizevar="Profit",
                    options=list(title = "An example of Bubble Chart",
                      hAxis='{title: "Sales", minValue:75, maxValue:125}',
                      vAxis='{title: "Expenses"}'
                      )
                     ) })
  
  output$scatter <- renderGvis({
    
    gvisScatterChart(women, 
                     options=list(
                      legend="none",
                       lineWidth=0, pointSize=1,
                       title="Example of Scatterplot using Women dataset", vAxis="{title:'weight (lbs)'}",
                       hAxis="{title:'height (in)'}", 
                       width=300, height=300))
    
    
  })
  
  output$guage <- renderGvis({
    
    gvisGauge(CityPopularity, 
              options=list(title= 'Example of Guage', min=0, max=800, greenFrom=500,
                           greenTo=800, yellowFrom=300, yellowTo=500,
                           redFrom=0, redTo=300, width=400, height=300))
    
    
  })
  
  
})
