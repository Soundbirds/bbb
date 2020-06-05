
Data visualization of the NY Times COVID-19 data (https://github.com/nytimes/covid-19-data) via R code using the googleVis package (https://github.com/mages/googleVis). With GitHub, the git app, and R coding the website is automatically updated with new NY Times data at an interval set in the 'mainloop.R' scirpt.

Browser requirements:

The browser needs to allow the Adobe Flash player to run, Firefox and Opera both make this an easy 2 clicks with clear prompting.
    
For Chrome see:
      https://support.google.com/chrome/answer/6258784?co=GENIE.Platform%3DDesktop&hl=en
    
   
The website for all 50 states is updated daily here (17" or larger screen recomended): https://soundbirds.github.io/NY.Times.COVID19.googleVis.github.io/COVID_states.htm
 
- Make an initial run without selecting any states.
- Single left mouse click on a circle to select (or unselect) a state, or select the states manually from the list. 
- After selection is complete, rerun.  The playback speed can be adjusted using the dial immediately to the right of the play button. 
- Hovering the mouse curser over any point will show all the data for that point.
- Hovering the mouse curser over the name of selected state hightlights the last point in that time series.
- Try changing both the x and y axis to log scale.
- Note that the x-variable can be switched to 'Time' after loading into the web browser is completed (googleVis hangs if xvar starts with the timevar).

The state data R code is below, adjust the width and height to your screen:


      library(googleVis)
      library(RCurl)

      # Note the need to use 'https://raw.githubusercontent.com' without 'blob', but with 'master' in the URL. This has to be correct, otherwise the result is html code or something broken.
      usStates <- read.csv(textConnection(getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")))
      usStates$date <- as.Date(usStates$date)
      usStates$newCases <- c(0, diff(usStates$cases))
      usStates$newDeaths <- c(0, diff(usStates$deaths))
 
      plot(gvisMotionChart(usStates[usStates$date > "2020-02-24", ], idvar = 'state', timevar = 'date', 
           xvar = 'deaths',  yvar = 'cases', sizevar = 'newCases', colorvar = 'newDeaths', options=list(width = 1024, height = 768)))


The website for the county data is updated daily here: https://soundbirds.github.io/NY.Times.COVID19.googleVis.github.io/COVID_counties.htm

For the county data, selecting too many states whose counties are displayed (last plot example) may be slow.
(Note, I do not use the fips (Federal Information Processing Standards) unique county codes since they are missing for the added cities (e.g. New York) and unknown county within a state data.)


      library(googleVis)
      library(RCurl)
      
      usCounties <- read.csv(textConnection(getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")))
      usCounties$date <- as.Date(usCounties$date)
      usCounties$newCases <- c(0, diff(usCounties$cases))
      usCounties$newDeaths <- c(0, diff(usCounties$deaths))
      usCounties$countyState <- paste(usCounties$county, usCounties$state, sep="_")
 
      State <- c('Washington', 'New York', 'California')[1]
      plot(gvisMotionChart(usCounties[usCounties$state %in% State & usCounties$date > "2020-02-24", ], idvar = 'county', timevar = 'date', 
                 xvar = 'deaths',  yvar = 'cases', sizevar = 'newCases', colorvar = 'newDeaths', options=list(width = 1024, height = 768)))
       
      # Counties inside 4 states 
      States <- c('Washington', 'New York', 'California', 'Louisiana')  # Switch states as desired - too many states is slow
      plot(gvisMotionChart(usCounties[usCounties$state %in% States & usCounties$date > "2020-02-24", ], idvar = 'countyState', timevar = 'date', 
                 xvar = 'deaths',  yvar = 'cases', sizevar = 'newCases', colorvar = 'newDeaths', options=list(width = 1024, height = 768)))
                        
    
P.S. Hans Rosling used the precursor of googleVis in an amazing Ted talk from 2006:
    https://www.youtube.com/watch?v=RUwS1uAdUcI
    

"In 2006 Hans Rosling gave an inspiring talk at
TED about social and economic developments
in the world over the past 50 years, which challenged the views and
perceptions of many listeners. Rosling had used extensive data analysis
to reach his conclusions.  To visualise his talk, he and his team at
Gapminder had developed animated bubble charts, aka
motion charts, see Figure. 

Rosling's presentation popularised the idea and use of interactive
charts. One year later the software behind
Gapminder was bought by Google and integrated as motion charts into
their Google Charts API, formerly known as Google
Visualisation API."
    https://github.com/mages/googleVis/blob/master/vignettes/googleVis.Rnw
    
    
    
     
     

