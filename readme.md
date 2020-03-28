
R code using googleVis package
   
By state:
    
- Switch the x-variable to 'Time' after loading into the web browser is completed
- Make an intial run without selecting any states.
- Single left mouse click on a circle to select (or unselect) a state, or select the states manually from the list.
- After selection is complete, rerun


      library(googleVis)
      library(RCurl)

      # usStates <- JRWToolBox::gitAFile("nytimes/covid-19-data/master/us-states.csv", 'csv', verbose = TRUE) # Code below from my JRWToolBox::gitAFile() function
     usStates <- read.csv(textConnection(getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")))
     usStates$date <- as.Date(usStates$date)

     plot(gvisMotionChart(usStates[usStates$date > "2020-02-24", ], idvar = 'state', timevar = 'date', 
           xvar = 'deaths',  yvar = 'cases', sizevar = 'cases', colorvar = 'deaths', options=list(width = 1024, height = 768)))


Counties within a state:

 - Switch the x-variable to 'Time' after loading into the web browser is completed
- Make an intial run without selecting any counties.
- Single left mouse click on a circle to select (or unselect) a county, or select the counties manually from the list.
- After selection is complete, rerun
    
     
      usCounties <- read.csv(textConnection(getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")))
      usCounties$date <- as.Date(usCounties$date)
    
      State <- c('Washington', 'New York')[1]
      plot(gvisMotionChart(usCounties[usCounties$state %in% State & usCounties$date > "2020-02-24", ], idvar = 'county', timevar = 'date', 
                 xvar = 'deaths',  yvar = 'cases', sizevar = 'cases', colorvar = 'deaths', options=list(width = 1024, height = 768)))
                 
  
     Published here (data as of 27 Mar 2020):
     
     https://soundbirds.github.io/NY.Times.COVID19.googleVis.github.io/
     
     
 
     
     
