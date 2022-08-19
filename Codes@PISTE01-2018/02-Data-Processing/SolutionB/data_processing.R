#----Loading libraries-------#
library(sets)
library(RMySQL)
library(DBI)
#----Fuzzy Logic : variable definition-------#

sets_options('universe', seq(from = 0,to = 4196, by = 1))
variables1 <-set(temperature =fuzzy_partition(varnames =c(cold = 0, medium = 25,hot = 50),sd = 12.5),
                 humidity =fuzzy_partition(varnames =c(wet = 0, medium = 37.5,dry = 75),sd = 18.75),
                 radiation =fuzzy_partition(varnames =c(low = 0, medium = 2098,intense = 4196),sd = 1049),
                 volume =fuzzy_partition(varnames =c(small = 0, medium = 50,big = 100),sd = 12.5))
rules1 <-set(
  fuzzy_rule(temperature %is% hot || humidity %is% wet || radiation %is% intense,
             volume %is% big),
  fuzzy_rule(temperature %is% cold || humidity %is% dry|| radiation %is% low,
             volume %is% small))
system1 <- fuzzy_system(variables1, rules1)
variables2 <-set(temperature =fuzzy_partition(varnames =c(cold = 0, medium = 25,hot = 50),sd = 12.5),
                 humidity =fuzzy_partition(varnames =c(wet = 0, medium = 37.5,dry = 75),sd = 18.75),
                 radiation =fuzzy_partition(varnames =c(low = 0, medium = 2098,intense = 4196),sd = 1049),
                 duration =fuzzy_partition(varnames =c(short = 0, medium = 30,long = 60),sd = 12.5))
rules2 <-set(
  fuzzy_rule(temperature %is% hot || humidity %is% wet || radiation %is% intense,
             duration %is% long),
  fuzzy_rule(temperature %is% cold || humidity %is% dry|| radiation %is% low,
             duration %is% short))
system2 <- fuzzy_system(variables2, rules2)


#----DataBase (Sensor_Data) variables retrieve -------#
mySqlCreds <- list(dbhostname ="localhost",
                   dbname ='PISTE01_2018',
                   username='PISTE01',
                   pass = 'iot',
                   port = 3306
)

count <- 1 

while (TRUE) {
  drv <- dbDriver("MySQL") 
  con<- dbConnect(
    drv,
    host = mySqlCreds$dbhostname,
    dbname = mySqlCreds$dbname,
    user =mySqlCreds$username,
    password = mySqlCreds$pass,
    port=mySqlCreds$port
  )
  RowQuery <- "SELECT COUNT(*) FROM Sensor_Data "
  rowscount <- dbGetQuery(con, RowQuery)
  
  while (count <= rowscount) {
    myQuery <- paste("SELECT * from Sensor_Data where Row_ID = '",count,"';",sep="")
    data.frame <- dbGetQuery(con, myQuery)
    
    #----Fuzzy Logic : Flow_Rate and Delay retrieve-------#
    options(digits=3)
    v1 <-  as.double(data.frame$temp)
    v2 <- as.double(data.frame$hum)
    v3 <- as.double(data.frame$lum)
    f1 <- fuzzy_inference(system1, list( temperature= v1, humidity= v2 , radiation=  v3  ))
    volume <- gset_defuzzify(f1, "centroid")
    f2 <- fuzzy_inference(system2, list( temperature=  v1, humidity= v2, radiation=  v3  ))
    delay <- gset_defuzzify(f2, "centroid")
    flowrate  <- volume / delay
    #----DataBase (Agro_Environmental_Parameters) Writing -------#
    values <- data.frame( 
      Row_ID= data.frame$row_id ,
      Sensor_ID= data.frame$sensor_id ,
      Temperature = data.frame$temp   , 
      Luminosity = data.frame$lum ,
      Humidity = data.frame$hum , 
      Time = data.frame$time , 
      Date =  data.frame$date , 
      Flow_Rate = flowrate ,
      Delay= delay 
    )
    
    dbWriteTable(con,"Agro_Environmental_Parameters",values, overwrite=FALSE,append=TRUE, row.names = FALSE)
    count <- count +1
  }
  #----Disconnect -------#
  dbDisconnect(con)
  Sys.sleep(5)
  print('Data stored successfully : Sleep Time before Relaunch!')
}




#lapply(dbListConnections(MySQL()), dbDisconnect)