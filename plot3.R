library(dplyr)
library(lubridate)

if (!dir.exists('./data')){dir.create('data')}
zipfile <- "./data/household_power_consumption.zip"
file <- "./data/household_power_consumption.txt"
if(!file.exists(zipfile) | !file.exists(file)){
    url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url = url, destfile = zipfile)
    unzip(zipfile, junkpaths = TRUE, exdir = "./data")    
}


dt <- read.table(file, nrows = 7, sep=";", header = TRUE)
start_data_obs <- dmy(dt$Date[1]) + hms(dt$Time[1])
obs_of_interest_strt <- strptime('2007-02-01 00:00:00', format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
nrows <- 48 * 60
rows_skip <- difftime(obs_of_interest_strt,start_data_obs, units = "mins") %>% as.numeric %>% sum(1)
col_classes = c('character', 'character', 'numeric','numeric','numeric','numeric','numeric','numeric','numeric' )
power_cons <- read.table(file, skip = rows_skip, nrows = nrows, sep=";", col.names = names(dt), stringsAsFactors = TRUE, colClasses = col_classes)
# merge date and time variables
power_cons <- power_cons %>% mutate(Date = paste(Date, Time)) %>% select(-Time)
power_cons$Date <- strptime(power_cons$Date, format = "%d/%m/%Y %H:%M:%S", tz = "UTC")

rdat <- mutate(power_cons, week = wday(Date, label = TRUE))
png(filename = "./data/plot3.png")
with(rdat, plot(Date, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(rdat, lines(Date, Sub_metering_2, col = "red"))
with(rdat, lines(Date, Sub_metering_3, col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"),
       text.col = "black", lwd = c(1, 1, 1))
dev.off()


