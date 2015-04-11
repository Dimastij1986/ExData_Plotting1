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
                           col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity",  "Sub_metering_1",  "Sub_metering_2",  "Sub_metering_3"), 
                           na.strings = "?",
                           skip = 1)

# omitting NAs 
data <- data_initial[complete.cases(data_initial[, 3]),]

# converting Date column to Date class
data$Date <- strptime(data$Date, "%d/%m/%Y")
data$Date <- as.Date(data$Date)

# filtering data and adding timestamp variable
filtdata <- data %>% filter(Date >= "2007-02-01" & Date <= "2007-02-02") %>% mutate(TimeStamp = as.POSIXct(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))

png(filename="plot4.png", width = 480, height = 480, units = "px")

# set up the plots and adding lines
par(mfrow=c(2,2))
with(filtdata, plot(TimeStamp, Global_active_power, type="n", xlab = "", ylab = "Global Active Power"))
with(filtdata, lines(TimeStamp, Global_active_power))

with(filtdata, plot(TimeStamp, Voltage, type="n", xlab = "datetime", ylab = "Voltage"))
with(filtdata, lines(TimeStamp, Voltage))

with(filtdata, plot(TimeStamp, Sub_metering_1, type="n", xlab = "", ylab = "Energy sub metering"))
with(filtdata, lines(TimeStamp, Sub_metering_1))
with(filtdata, lines(TimeStamp, Sub_metering_2, col = "red"))
with(filtdata, lines(TimeStamp, Sub_metering_3, col = "blue"))
legend("topright", pch=c(NA,NA,NA), col=c("black", "red", "blue"), lwd=1, box.col = "white", inset = .03, cex=0.9, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

with(filtdata, plot(TimeStamp, Global_reactive_power, type="n", xlab = "datetime", ylab = "Global_reactive_power"))
with(filtdata, lines(TimeStamp, Global_reactive_power))

#saving as plot3.png
dev.copy(png, file="plot4.png")
dev.off()