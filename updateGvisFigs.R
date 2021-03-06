      library(googleVis)
      library(RCurl)
      library(housingData)
      
      # gvisMotionChart on State data

      # usStates <- JRWToolBox::gitAFile("nytimes/covid-19-data/master/us-states.csv", 'csv', verbose = TRUE) # Code below from my JRWToolBox::gitAFile() function
      # Note the need to use 'https://raw.githubusercontent.com' without 'blob', but with 'master' in the URL. This has to be correct, otherwise the reuslt is html code or something broken.
      
      usStates <- read.csv(textConnection(getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")))
      usStates$date <- as.Date(usStates$date)
      usStates$deathsPer1000Cases <- 1000 * usStates$deaths/usStates$cases
      cat("\nStates' data latest date:", format(usStates$date[nrow(usStates)]), "\n")
      
      casesNewByState <- NULL
      deathsNewByState <- NULL
      caseDoubleByState <- NULL
      for ( i in unique(usStates$state))  {
        # print(i)
        stateData <- usStates[usStates$state %in% i, ]
        casesNewByState <- rbind(casesNewByState, data.frame(date = stateData$date, state = stateData$state, newCases = c(0, diff(stateData$cases))))
        deathsNewByState <- rbind(deathsNewByState, data.frame(date = stateData$date, state = stateData$state, newDeaths = c(0, diff(stateData$deaths))))
        # Checked 'Rule of 70' but just the inverse (i.e. 100 instead of 70) appears more accuate for this data
        # caseDoubleByState <- rbind(caseDoubleByState, data.frame(date = stateData$date, state = stateData$state, casesStateDoublingRate = c(0, 70/(100 * diff(log(stateData$cases, 2))))))
        caseDoubleByState <- rbind(caseDoubleByState, data.frame(date = stateData$date, state = stateData$state, casesStateDoublingRate = c(0, 1/diff(log(stateData$cases, 2)))))
      }
      
      usStates <-  match.f(usStates, casesNewByState, c('date', 'state'), c('date', 'state'), 'newCases')
      usStates <-  match.f(usStates, deathsNewByState, c('date', 'state'), c('date', 'state'), 'newDeaths')
      usStates <-  match.f(usStates, caseDoubleByState, c('date', 'state'), c('date', 'state'), 'casesStateDoublingRate')
      usStates$casesStateDoublingRate[!is.finite(usStates$casesStateDoublingRate) | usStates$casesStateDoublingRate > 40] <- NA
     
 
      Ms <- googleVis::gvisMotionChart(usStates[usStates$date > "2020-02-24", ], idvar = 'state', timevar = 'date', 
           xvar = 'deaths',  yvar = 'cases', sizevar = 'newCases', colorvar = 'newDeaths', options=list(width = 1365, height = 768))
      # googleVis:::plot.gvis(Ms)  
      googleVis:::print.gvis(Ms, file = 'COVID_states.htm')


      # gvisMotionChart on County data

      usCounties <- read.csv(textConnection(getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")))
      usCounties$date <- as.Date(usCounties$date)
      usCounties$cases[usCounties$deaths > usCounties$cases] <- (usCounties$cases + usCounties$deaths)[usCounties$deaths > usCounties$cases] 
      # usCounties$deathsPer1000Cases <- 1000 * usCounties$deaths/usCounties$cases  # Not enough cases within some counties
      usCounties$countyState <- paste(usCounties$county, usCounties$state, sep="_")
      cat("\nCounties' data latest date:", format(usCounties$date[nrow(usCounties)]), "\n\n")
      
      casesNewByCounty <- NULL
      deathsNewByCounty <- NULL
      caseDoubleByCounty <- NULL
      for ( i in unique(usCounties$countyState))  {
        # print(i)
        countyData <- usCounties[usCounties$countyState %in% i, ]
        casesNewByCounty <- rbind(casesNewByCounty, data.frame(date = countyData$date, countyState = countyData$countyState, newCases = c(0, diff(countyData$cases))))
        deathsNewByCounty <- rbind(deathsNewByCounty, data.frame(date = countyData$date, countyState = countyData$countyState, newDeaths = c(0, diff(countyData$deaths))))
        caseDoubleByCounty <- rbind(caseDoubleByCounty, data.frame(date = countyData$date, countyState = countyData$countyState, casesCntyDoublingRate = c(0, 1/diff(log(countyData$cases, 2)))))
        # usCountiesLast <- rbind(usCountiesLast, data.frame(countyState = countyData$countyState, fips = countyData$fips, 
        #     latestCases = countyData$cases[countyData$date %in% max(countyData$date)], latestDeaths = countyData$deaths[countyData$date %in% max(countyData$date)]))
     }
      
      usCounties <-  match.f(usCounties, casesNewByCounty, c('date', 'countyState'), c('date', 'countyState'), 'newCases')
      usCounties <-  match.f(usCounties, deathsNewByCounty, c('date', 'countyState'), c('date', 'countyState'), 'newDeaths')
      usCounties <-  match.f(usCounties, caseDoubleByCounty, c('date', 'countyState'), c('date', 'countyState'), 'casesCntyDoublingRate')
      usCounties$casesCntyDoublingRate[!is.finite(usCounties$casesCntyDoublingRate) | usCounties$casesCntyDoublingRate > 40] <- NA # Extreme cases removed
     
 
      # State <- c('Washington', 'New York', 'California')[1]
      # plot(gvisMotionChart(usCounties[usCounties$state %in% State & usCounties$date > "2020-02-24", ], idvar = 'county', timevar = 'date', 
      #            xvar = 'deaths',  yvar = 'cases', sizevar = 'newCases', colorvar = 'newDeaths', options=list(width = 1365, height = 768)))
       
      # Counties inside 4 states 
      States <- c('Washington', 'New York', 'California', 'Louisiana')
      Mc <- googleVis::gvisMotionChart(usCounties[usCounties$state %in% States & usCounties$date > "2020-02-24", ], idvar = 'countyState', timevar = 'date', 
           xvar = 'deaths',  yvar = 'cases', sizevar = 'newCases', colorvar = 'newDeaths', options=list(width = 1365, height = 768))
      # googleVis:::plot.gvis(Mc)      
      googleVis:::print.gvis(Mc, file = 'COVID_counties.htm')    

     
      # Some of the NY Times data like New York city don't have a fips, and some important fips are missing from housingData::geoCounty - so can't do this correctly!!!!!!!
      # # gvisGeoChart on latest County (fips) data (NY Times data is cummulative so just need that latest date)
      
      # usCountiesLast <- usCountiesLast[!duplicated(usCountiesLast$countyState), ]
      # usCountiesLast <- match.f(usCountiesLast, housingData::geoCounty, 'fips', 'fips', c('lon', 'lat'), round = FALSE) # lat/lon centroid of the counties from housingData package
      # usCountiesLast <- renum(na.omit(usCountiesLast))
      # usCountiesLast$LatLong <- paste0(usCountiesLast$lat,":", usCountiesLast$lon) 
      # maxD <- max(usCountiesLast$latestDeaths)
      # cMax <- gvisGeoChart(usCountiesLast, "LatLong", sizevar = 'latestCases', colorvar = 'latestDeaths', 
      #           options=list(region='US', width = 1365, height = 768, 
      #                                    displayMode='markers',
      #    colorAxis=paste0("{values:[1, ", 0.25*maxD, ", ", 0.50*maxD, ", ", 0.75*maxD, ", ", maxD, "], ",
      #                                    "colors:['#FFFF00', '#EEEE00', '#EE2C2C', '#CD2626', '#8B1A1A']}")))
      #  # googleVis:::plot.gvis(cMax)
      #  googleVis:::print.gvis(cMax, file = 'index.htm')  # Put this Geo Chart on the main index.htm
      #  
  
