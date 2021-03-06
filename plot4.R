#========================================================
#Please note: file "household_power_consumption.txt" 
#must be in subdir "./data" ie a subdir called "data"
#of your current working directory for this script
#========================================================

#========================================================
#read data, put into plottable form
#========================================================
#uses data.table fread
#gives fastest read (?)
#store in data.frame (not data.table)
#need to explicitly set colClasses, 
#as otherwise cols are bumped from char to numeric because of missing data

library(data.table)

#unzipped data file is assumed to be in sub-dir of working-dir
#has missing values coded as '?'
data_path <- "./data"
fname <- "household_power_consumption.txt"
pfname <- sprintf("%s/%s", data_path, fname)
#df<-fread(pfname, sep = ";", colClasses = c(rep('character',9)), na.strings='?', verbose=TRUE, data.table=FALSE)
df<-fread(pfname, sep = ";", colClasses = c(rep('character',9)), na.strings='?', verbose=FALSE, data.table=FALSE)

#========================================================
#select plot data (rows)
#========================================================

library(dplyr)

#select only rows of data from the dates 2007-02-01 and 2007-02-02
#Date: Date in format dd/mm/yyyy 
#that is "01/02/2007" and "02/02/2007"
#but dates in txt file do not have leading zero

date1 <- "1/2/2007" 
date2 <- "2/2/2007"

dfplot <- filter(df, Date == date1 | Date == date2)

#========================================================
#set column types 
#========================================================

#change columns 3:9 from char to numeric
dfplot[,c(3:9)]<-sapply(dfplot[,c(3:9)], as.numeric)

#set data and time cols
library(lubridate)

#join date and time, new column name datetime
dfplot <- mutate(dfplot, DateTime = sprintf("%s %s", Date, Time) )

#now set to date, time data_time objects
dfplot <- mutate(dfplot, Date = dmy(Date), Time = hms(Time), DateTime = dmy_hms(DateTime) )

#========================================================


#========================================================
#Construct the plot and save it to a PNG file 
#with a width of 480 pixels and a height of 480 pixels.
#graphics device png has 480 x 480 as default on linux
#========================================================
#start plot number: 4
#========================================================

plotname="plot4.png"

png(filename = plotname, width = 480, height = 480)

#plot
#set up 2 row 2 col plot
par(mfrow = c(2, 2))

#plot(1,1)

title=""
xlab<-""
ylab<-"Global Active Power"
with(dfplot, plot(DateTime, Global_active_power , type='l', lty=1, main=title, xlab=xlab, ylab=ylab) )

#plot(1,2)

title=""
xlab<-"datetime"
ylab<-"Voltage"

with(dfplot, plot(DateTime, Voltage , type='l', lty=1, main=title, xlab=xlab, ylab=ylab))

#plot(2,1)

title=""
xlab<-""
ylab<-"Energy sub metering"
with(dfplot, plot(DateTime, Sub_metering_1, type='l', lty=1, main=title, xlab=xlab, ylab=ylab))
with(dfplot, lines(DateTime, Sub_metering_2, lty=1, col="red"))
with(dfplot, lines(DateTime, Sub_metering_3, lty=1, col="blue"))

legend <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
legend("topright", lty=1, col = c("black","red","blue"), legend=legend)




#plot(2,2)

title=""
xlab<-"datetime"
ylab<-"Global_reactive_power"
with(dfplot, plot(DateTime, Global_reactive_power , type='l', lty=1, main=title, xlab=xlab, ylab=ylab))



#off
dev.off()




