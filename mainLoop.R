# dir.create("C:/Users/John/", showWarnings = FALSE, recursive = TRUE)

while(TRUE) {
    
    setwd("C:/Users/John/")
    
    shell("echo git config --global user.name 'John Wallace' > run.bat")
    shell("echo git config --global user.email 'soundbirds@gmail.com'  >> run.bat")
    shell("echo git clone https://github.com/Soundbirds/NY.Times.COVID19.googleVis.github.io.git  >> run.bat")
    shell("echo exit >> run.bat")
    shell("start run.bat")
    Sys.sleep(3)
    shell("del run.bat")
    Sys.sleep(3)
    
    setwd("C:/Users/John/NY.Times.COVID19.googleVis.github.io")
    source('updateGvisFigs.R') 
    
    shell("start Push.bat")
    
    print(timestamp())
           
    Sys.sleep(6*3600)
}   
 

