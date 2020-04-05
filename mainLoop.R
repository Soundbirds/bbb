# dir.create("C:/Users/John/", showWarnings = FALSE, recursive = TRUE)

while(TRUE) {
    
    setwd("C:/Users/John/")
    
    shell("echo git config --global user.name 'John Wallace' > run.bat")
    shell("echo git config --global user.email 'soundbirds@gmail.com'  >> run.bat")
    shell("echo git clone https://github.com/Soundbirds/NY.Times.COVID19.googleVis.github.io.git  >> run.bat")
    shell("echo exit >> run.bat")
    shell("start run.bat")
    Sys.sleep(15)
    shell("del run.bat")
    Sys.sleep(3)
    
    setwd("C:/Users/John/NY.Times.COVID19.googleVis.github.io")
    source('updateGvisFigs.R')
    shell("start Push.bat")
    Sys.sleep(15)
    setwd("C:/Users/John/")
    system(paste0("rm -r ", "NY.Times.COVID19.googleVis.github.io"))
    
    timestamp()
   
    hoursPause <- 3  # Gives the time that has past every 30 minutes
    cat("\n\nStarting to pause for", hoursPause, "hours\n")
    for(i in 1:(hoursPause * 2)) {
       Sys.sleep(30 * 60)
       cat("\n\n", round((i * 5)/60, 3), "hours out of", hoursPause, "hours have passed\n")
       timestamp()
    }
}   




