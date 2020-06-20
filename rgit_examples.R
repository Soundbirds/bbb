
# ------------- Soundbirds -----------------------

repoPath <- c("John-R-Wallace-NOAA/JRWToolBox", "John-R-Wallace-NOAA/rgit", "Soundbirds/NY.Times.COVID19.googleVis.github.io")[3]
 gitName <- c("John-R-Wallace-NOAA", "Soundbirds")[2]
gitEmail <- c("john.wallace@noaa.gov", "soundbirds@gmail.com")[2]



library(JRWToolBox)
JRWToolBox::lib(rgit, attach = FALSE)

rgit::S(mainLoop, gitPath = 'Soundbirds/NY.Times.COVID19.googleVis.github.io/master/', viewOnly = TRUE, run = TRUE)




repoPath <- c("John-R-Wallace-NOAA/JRWToolBox", "John-R-Wallace-NOAA/rgit", "Soundbirds/NY.Times.COVID19.googleVis.github.io")[3]

S(mainLoop, subDir = NULL, verbose = T)

gitPush(mainLoop, subDir = NULL, verbose = T, autoExit = F)



# ------------ rgit  --------------------

repoPath <- c("John-R-Wallace-NOAA/JRWToolBox", "John-R-Wallace-NOAA/rgit", "Soundbirds/NY.Times.COVID19.googleVis.github.io")[2]
 gitName <- c("John-R-Wallace-NOAA", "Soundbirds")[1]
gitEmail <- c("john.wallace@noaa.gov", "soundbirds@gmail.com")[1]


S(S)


S(gitEqual, verbose = T)


gitPush(gitPush)

gitPush(gitPush, subDir = NULL, verbose = T, autoExit = F)






















