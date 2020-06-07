  
  gVisCOVID.NYT.Data <- function(countyStates = NULL, width = 1400, height = 800, Print = FALSE) {
      
      # Hello 
      library(JRWToolBox)
      JRWToolBox::lib(googleVis)
      JRWToolBox::lib(RCurl)
            
      ma <- function(x, n = 21) { stats::filter(x, rep(1 / n, n), sides = 2) }
      
      # gvisMotionChart on State data
         
      if(is.null(countyStates)) {   
         
          # usStates <- JRWToolBox::gitAFile("nytimes/covid-19-data/master/us-states.csv", 'csv', verbose = TRUE) # Code below from my JRWToolBox::gitAFile() function
          # Note the need to use 'https://raw.githubusercontent.com' without 'blob', but with 'master' in the URL. This has to be correct, otherwise the reuslt is html code or something broken.
          
          usStates <- read.csv(textConnection(RCurl::getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")))
          usStates$date <- as.Date(usStates$date)
          cat("\nStates' data latest date:", format(usStates$date[nrow(usStates)]), "\n\n")
          
          NewByStateCD <- NULL
          caseDoubleByState <- NULL
          deathsPer1000 <- NULL
          for ( i in unique(usStates$state))  {
            # print(i)
            stateData <- usStates[usStates$state %in% i, ]
            stateCD <- data.frame(date = stateData$date, state = stateData$state, newCases = c(0, diff(stateData$cases)), newDeaths = c(0, diff(stateData$deaths)))
            # print(c(i, nrow(stateCD)))       
            NewByStateCD <- rbind(NewByStateCD, stateCD)
            # Checked 'Rule of 70' but just the (mathematical) inverse (i.e. 100 instead of 70) appears more accuate for this data
            # caseDoubleByState <- rbind(caseDoubleByState, data.frame(date = stateData$date, state = stateData$state, casesStateDoublingRate = c(0, 70/(100 * diff(log(stateData$cases, 2))))))
            caseDoubleByState <- rbind(caseDoubleByState, data.frame(date = stateData$date, state = stateData$state, casesStateDoublingRate = c(0, 1/diff(log(stateData$cases, 2)))))
            if(nrow(stateCD) > 21) 
                   deathsPer1000 <- rbind(deathsPer1000, data.frame(date = stateData$date, state = stateData$state, nwDthsPer1knwCases2WkAgo = 
                               1000 * stateCD$newDeaths/c(rep(NA, 14), ma(stateCD$newCases, 21)[1:(length(stateCD$newCases) - 14)]), nwDthsPer1knwCasesMthAgo = 
                               if(nrow(stateCD) > 28) 1000 * stateCD$newDeaths/c(rep(NA, 28), ma(stateCD$newCases, 21)[1:(length(stateCD$newCases) - 28)])
                               else rep(NA, nrow(stateCD)) ))
          }
          
          usStates <- match.f(usStates, NewByStateCD, c('date', 'state'), c('date', 'state'), c('newCases', 'newDeaths'))
          usStates <- match.f(usStates, caseDoubleByState, c('date', 'state'), c('date', 'state'), 'casesStateDoublingRate')
          usStates$casesStateDoublingRate[!is.finite(usStates$casesStateDoublingRate) | usStates$casesStateDoublingRate < 0| usStates$casesStateDoublingRate > 200] <- NA
          usStates <- match.f(usStates, deathsPer1000, c('date', 'state'), c('date', 'state'), c('nwDthsPer1knwCases2WkAgo', 'nwDthsPer1knwCasesMthAgo'))
          usStates$nwDthsPer1knwCases2WkAgo[!is.finite(usStates$nwDthsPer1knwCases2WkAgo) | usStates$nwDthsPer1knwCases2WkAgo < 0 | usStates$nwDthsPer1knwCases2WkAgo > 1000] <- NA
          usStates$nwDthsPer1knwCasesMthAgo[!is.finite(usStates$nwDthsPer1knwCasesMthAgo) | usStates$nwDthsPer1knwCasesMthAgo < 0 | usStates$nwDthsPer1knwCasesMthAgo > 1000] <- NA
          
          
          oldOpt <- options(warn = -1)
          usStates$logCases <- log(usStates$cases)
          usStates$logCases[!is.finite(usStates$logCases)] <- NA          
          usStates$logDeaths <- log(usStates$deaths)
          usStates$logDeaths[!is.finite(usStates$logDeaths)] <- NA          
          usStates$logNewCases <- log(usStates$newCases)
          usStates$logNewCases[!is.finite(usStates$logNewCases)] <- NA          
          usStates$logNewDeaths <- log(usStates$newDeaths)
          usStates$logNewDeaths[!is.finite(usStates$logNewDeaths)] <- NA          
          names(usStates)[grep('fips', names(usStates))] <- "fipsUniqueSt"
          options(oldOpt)

          Ms <- googleVis::gvisMotionChart(usStates[usStates$date > "2020-02-24", ], idvar = 'state', timevar = 'date', 
               xvar = 'deaths',  yvar = 'cases', sizevar = 'nwDthsPer1knwCasesMthAgo', colorvar = 'logNewDeaths', options=list(width = width, height = height))
         
          if(Print)
             googleVis:::print.gvis(Ms, file = 'COVID_states.htm')  
          if(!Print)
             googleVis:::plot.gvis(Ms)
      } 
      

      # gvisMotionChart on County data
      
      if(!is.null(countyStates)) {  
      
          usCounties <- read.csv(textConnection(RCurl::getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")))
          usCounties$date <- as.Date(usCounties$date)
          usCounties$cases[usCounties$deaths > usCounties$cases] <- (usCounties$cases + usCounties$deaths)[usCounties$deaths > usCounties$cases] 
          # usCounties$deathsPer1000Cases <- 1000 * usCounties$deaths/usCounties$cases  # Not enough cases within some counties
          usCounties$countyState <- paste(usCounties$county, usCounties$state, sep="_")
          cat("\nCounties' data latest date:", format(usCounties$date[nrow(usCounties)]), "\n\n")
          usCounties <- usCounties[usCounties$state %in% countyStates, ]
          
          NewByCountyCD <- NULL
          caseDoubleByCounty <- NULL
          deathsPer1000 <- NULL
          for ( i in unique(usCounties$countyState))  {
            # print(i)
            countyData <- usCounties[usCounties$countyState %in% i, ]
            countyCD <- data.frame(date = countyData$date, countyState = countyData$countyState, newCases = c(0, diff(countyData$cases)), newDeaths = c(0, diff(countyData$deaths)))
            # print(c(i, nrow(countyCD)))       
            NewByCountyCD <- rbind(NewByCountyCD, countyCD)
            # Checked 'Rule of 70' but just the (mathematical) inverse (i.e. 100 instead of 70) appears more accuate for this data
            # caseDoubleByCounty <- rbind(caseDoubleByCounty, data.frame(date = countyData$date, county = countyData$county, casesCountyDoublingRate = c(0, 70/(100 * diff(log(countyData$cases, 2))))))
            caseDoubleByCounty <- rbind(caseDoubleByCounty, data.frame(date = countyData$date, countyState = countyData$countyState, casesCountyDoublingRate = c(0, 1/diff(log(countyData$cases, 2)))))
            if(nrow(countyCD) > 21)
               deathsPer1000 <- rbind(deathsPer1000, data.frame(date = countyData$date, countyState = countyData$countyState, nwDthsPer1knwCases2WkAgo = 
                               1000 * countyCD$newDeaths/c(rep(NA, 14), ma(countyCD$newCases, 21)[1:(length(countyCD$newCases) - 14)]), nwDthsPer1knwCasesMthAgo = 
                               if(nrow(countyCD) > 28) 1000 * countyCD$newDeaths/c(rep(NA, 28), ma(countyCD$newCases, 21)[1:(length(countyCD$newCases) - 28)]) 
                               else rep(NA, nrow(countyCD)) ))
         }    
          
          usCounties <-  match.f(usCounties, NewByCountyCD, c('date', 'countyState'), c('date', 'countyState'), c('newCases', 'newDeaths'))
          usCounties <-  match.f(usCounties, caseDoubleByCounty, c('date', 'countyState'), c('date', 'countyState'), 'casesCountyDoublingRate')
          usCounties$casesCountyDoublingRate[!is.finite(usCounties$casesCountyDoublingRate) | usCounties$casesCountyDoublingRate < 0| usCounties$casesCountyDoublingRate > 200] <- NA
          usCounties <-  match.f(usCounties, deathsPer1000, c('date', 'countyState'), c('date', 'countyState'), c('nwDthsPer1knwCases2WkAgo', 'nwDthsPer1knwCasesMthAgo'))
          usCounties$nwDthsPer1knwCases2WkAgo[!is.finite(usCounties$nwDthsPer1knwCases2WkAgo) | usCounties$nwDthsPer1knwCases2WkAgo < 0 | usCounties$nwDthsPer1knwCases2WkAgo > 1000] <- NA
          usCounties$nwDthsPer1knwCasesMthAgo[!is.finite(usCounties$nwDthsPer1knwCasesMthAgo) | usCounties$nwDthsPer1knwCasesMthAgo < 0 | usCounties$nwDthsPer1knwCasesMthAgo > 1000] <- NA
          
          
          oldOpt <- options(warn = -1)
          usCounties$logCases <- log(usCounties$cases)
          usCounties$logCases[!is.finite(usCounties$logCases)] <- NA
          usCounties$logDeaths <- log(usCounties$deaths)
          usCounties$logDeaths[!is.finite(usCounties$logDeaths)] <- NA
          usCounties$logNewCases <- log(usCounties$newCases)
          usCounties$logNewCases[!is.finite(usCounties$logNewCases)] <- NA
          usCounties$logNewDeaths <- log(usCounties$newDeaths)
          usCounties$logNewDeaths[!is.finite(usCounties$logNewDeaths)] <- NA
          names(usCounties)[grep('fips', names(usCounties))] <- "fipsPlusUniq"
          options(oldOpt)
          
          # Add a unique (negative) code to the cities and unknown states without a fips number (e.g. "New York City_New York" "Unknown_Michigan" )
          missingFips <- unique(usCounties$countyState[is.na(usCounties$fipsPlusUniq)])
          missingFips <- data.frame(countyState =  missingFips, newUniqCode = -(1:length(missingFips)))
          usCounties <- match.f(usCounties, missingFips, "countyState", "countyState", "newUniqCode")
          usCounties$fipsPlusUniq[is.na(usCounties$fipsPlusUniq)] <- usCounties$newUniqCode[is.na(usCounties$fipsPlusUniq)]
          usCounties$newUniqCode <- NULL
          
           
          # Counties inside 4 states 
          Mc <- googleVis::gvisMotionChart(usCounties[usCounties$date > "2020-02-24", ], idvar = 'countyState', timevar = 'date', 
               xvar = 'deaths',  yvar = 'cases', sizevar = 'nwDthsPer1knwCasesMthAgo', colorvar = 'logNewDeaths', options=list(width = width, height = height))
                 
          if(Print)
             googleVis:::print.gvis(Mc, file = 'COVID_counties.htm')  
          if(!Print)
             googleVis:::plot.gvis(Mc)
     }
  }    
  



