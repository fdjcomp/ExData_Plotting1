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
#start plot number: 1 
#========================================================

plotname="plot1.png"

png(filename = plotname, width = 480, height = 480)

#plot

title="Global Active Power"
xlab<-"Global Active Power (kilowatts)"
ylab<-"Frequency"
with(dfplot, hist(Global_active_power, col="red", main=title, xlab=xlab, ylab=ylab))

#off
dev.off()




