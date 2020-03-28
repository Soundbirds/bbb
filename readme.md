



library(googleVis)

usCounties <- gitAFile("nytimes/covid-19-data/master/us-counties.csv", 'csv')
usCounties$date <- as.Date(usCounties$date)
States <- c('Washington', 'New York')[2]

# Switch the x-variable to 'Time' after loading into the web browser is completed
# Make an intial run without selecting any counties.
# Single left mouse click on a circle to select (or unselect) a county, or select the counties manaully from the list.
# After selection is complete, rerun


plot(gvisMotionChart(usCounties[usCounties$state %in% States & usCounties$date > "2020-02-24",], idvar = 'county', timevar = 'date', 
                 xvar = 'deaths',  yvar = 'cases', sizevar = 'cases', colorvar = 'deaths', options=list(width = 1024, height = 768)))
                 
  
M1 <- gvisMotionChart(usCounties[usCounties$state %in% States & usCounties$date > "2020-02-24",], idvar = 'county', timevar = 'date', 
                 xvar = 'deaths',  yvar = 'cases', sizevar = 'cases', colorvar = 'deaths', options=list(width = 1024, height = 768))            
     
