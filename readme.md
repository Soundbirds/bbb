
R code using googleVis package


     library(googleVis)
     library(RCurl)

     # usCounties <- JRWToolBox::gitAFile("nytimes/covid-19-data/master/us-counties.csv", 'csv', verbose = TRUE) # Code from my gitAFile()
     usCounties <-  read.csv(textConnection(getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")))
     usCounties$date <- as.Date(usCounties$date)
     

- Switch the x-variable to 'Time' after loading into the web browser is completed
- Make an intial run without selecting any counties.
- Single left mouse click on a circle to select (or unselect) a county (state), or select the counties (states) manually from the list.
- After selection is complete, rerun

      State <- c('Washington', 'New York')[1]
      plot(gvisMotionChart(usCounties[usCounties$state %in% State & usCounties$date > "2020-02-24",], idvar = 'county', timevar = 'date', 
                 xvar = 'deaths',  yvar = 'cases', sizevar = 'cases', colorvar = 'deaths', options=list(width = 1024, height = 768)))
                 
  
     Published here (data as of 27 Mar 2020):
     
     https://soundbirds.github.io/NY.Times.COVID19.googleVis.github.io/
     
       
     
     
