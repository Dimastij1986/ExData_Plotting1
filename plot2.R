#loading necessary libraries
library(dplyr)

#downloading (if needed) and loading file in R
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("household_power_consumption.zip")) {
  cat("Downloading...")
  download.file(fileUrl, destfile = "./household_power_consumption.zip")
}

data_initial <- read.table(unz("./household_power_consumption.zip", "household_power_consumption.txt"), 
                           sep=";", 
                           col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity",  "Sub_metering_1",	"Sub_metering_2",	"Sub_metering_3"), 
                           na.strings = "?",
                           skip = 1)

# omitting NAs 
data <- data_initial[complete.cases(data_initial[, 3]),]

# converting Date column to Date class
data$Date <- strptime(data$Date, "%d/%m/%Y")
data$Date <- as.Date(data$Date)

# filtering data and adding timestamp variable
filtdata <- data %>% filter(Date >= "2007-02-01" & Date <= "2007-02-02") %>% mutate(TimeStamp = as.POSIXct(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))

# creating plot2 and saving as plot2.png
png(filename="plot2.png", width = 480, height = 480, units = "px")

with(filtdata, plot(TimeStamp, Global_active_power, type="n", xlab = "", ylab = "Global Active Power (kilowatts)"))
with(filtdata, lines(TimeStamp, Global_active_power))
dev.copy(png, file="plot2.png")
dev.off()
