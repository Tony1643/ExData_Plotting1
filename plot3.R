df <- NULL
c <- file("household_power_consumption.txt","r")
rl <- readLines(c, n=1) ## discard line 1 which are column headings

while(TRUE) {

  rl <- readLines(c, n=1)     ## Reads line as a single string

  if (length(rl) == 0) {      
    close(c)
    break                     ## test EOF reached
  } else {
    rl <- unlist(strsplit(rl, split=";")) ## Splits the line into a 9 element character vector
    if ((rl[1] == "1/2/2007") || (rl[1] == "2/2/2007")) {
    if (is.null(df)) {
      df <- rl
    } else {
      df <- rbind(df, rl)
    }
    }
    }
}
row.names(df) <- NULL
df <- data.frame(df, stringsAsFactors = FALSE)
names(df) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", 
                  "Voltage", "Global_intensity", "Sub_metering_1",
                  "Sub_metering_2", "Sub_metering_3")

df$Time <- strptime(paste(df$Date," ", df$Time, sep=""), format = "%d/%m/%Y %H:%M:%S")
df$Date <- as.Date(df$Date, format = "%d/%m/%Y")
df$Global_active_power <- as.numeric(df$Global_active_power)
df$Global_reactive_power <- as.numeric(df$Global_reactive_power)
df$Voltage <- as.numeric(df$Voltage)
df$Global_intensity <- as.numeric(df$Global_intensity)
df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)
df$Sub_metering_3 <- as.numeric(df$Sub_metering_3)

png(filename = "plot3.png", width = 480, height = 480, units = "px")


plot(df$Time, df$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
points(df$Time, df$Sub_metering_2, type="l", col="red")
points(df$Time, df$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex=.93, lty=1, col=c("black", "red", "blue"))

dev.off()