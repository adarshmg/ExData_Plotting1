library(RSQLite)

# Download file 
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile ="house_power_consumption.zip")
# Unzip file  
unzip("house_power_consumption.zip")


## Next few steps, write the text file into a SQLite DB file and load only the 
## the required data from the file, this is faster than loading the entire
## file into memory and taking a subset.
con <- dbConnect(RSQLite::SQLite(),dbname="power_consumption.sqlite")
dbWriteTable(con, name="power_consumption", value="household_power_consumption.txt",row.names=FALSE, header=TRUE, sep = ";",overwrite = TRUE)
res <- dbSendQuery(con,"SELECT * FROM power_consumption where Date in ('1/2/2007','2/2/2007') or ( Date = '3/2/2007' and Time = '00:00:00');")
dt <- dbFetch(res,n=-1)
##
# Clean up result set variable and close the connection.
##
dbClearResult(res)
dbDisconnect(con)

# set the margins and the panels in the plot.
par(mfrow=c(2,2),mar=c(4,4,1,1))

dttime <- strptime(paste(dt$Date,dt$Time,sep = " "),
                   format = "%d/%m/%Y %H:%M:%S",tz="")

#
# Plot the 4 different charts in different panels.
# 

with(dt,{
        plot(dttime,
             Global_active_power,
             xlab="",
             ylab = "Global Active Power",
             type = "l")
        plot(dttime,
             Voltage,
             xlab="datetime",
             ylab = "Voltage",
             type = "l")
        plot(dttime,Sub_metering_1,
             xlab="",
             ylab = "Energy sub metering",
             type = "l")
        with(dt,points(dttime,Sub_metering_2,col="red",type="l"))
        with(dt,points(dttime,Sub_metering_3,col="blue",type="l"))
        legend("topright",lty=c(1,1,1), col=c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),cex=0.5)
        plot(dttime,
             Global_reactive_power,
             xlab="datetime",
             ylab = "Global_reactive_power",
             type = "l")
        

})
##
# Create a png file out of the plot.
## 
dev.copy(png,file="plot4.png")
dev.off()