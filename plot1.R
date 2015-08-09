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

##
# Create a date time field by combining the Date and Time field in dataframe.
##
dt$datetime <- strptime(paste(dt$Date,dt$Time,sep = " "),format = "%d/%m/%Y %H:%M:%S",tz="")

##
# Plot the histogram.
##
hist(dt$Global_active_power,col="red",main = "Global Active Power",xlab = "Global Active Power (kilowatts)")

##
# Create a copy of the histogram as a png file.
##
dev.copy(png,file="plot1.png")
dev.off()
