library(dplyr)
library(lubridate)

# Downloading and unzip data from source
if (!dir.exists('./data')){dir.create('data')}
zipfile <- "./data/household_power_consumption.zip"
file <- "./data/household_power_consumption.txt"
if(!file.exists(zipfile) | !file.exists(file)){
    url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url = url, destfile = zipfile)
    unzip(zipfile, junkpaths = TRUE, exdir = "./data")    
}

# Read few first rows of data, for first look on data, to get a start date and time of 
# observation and get it's col(variables names). 
dt <- read.table(file, nrows = 7, sep=";", header = TRUE)
start_data_obs <- dmy(dt$Date[1]) + hms(dt$Time[1])
obs_of_interest_strt <- strptime('2007-02-01 00:00:00', format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

# While exploring data we see that observation was made every minute
nrows <- 48 * 60
rows_skip <- difftime(obs_of_interest_strt,start_data_obs, units = "mins") %>% as.numeric %>% sum(1)
power_cons <- read.table(file, skip = rows_skip, nrows = nrows, sep=";", col.names = names(dt))

# Create plot and write in to png file.
png(filename = './data/plot1.png')
hist(power_cons$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
dev.off()
