## Include libraries to modify data and convert the dates easily
require(plyr);
require(dplyr);
require(lubridate);

importData <- function(filename = "household_power_consumption.txt", startRow = 66638, endRow = 69517) {
  ## Import data function
  ## imports filename with headers from rows startRow to endRow
  ## defaults for this project as:
  ##  filename = "household_power_consumption.txt"
  ##  startRow = 66638  ## 2007-02-01
  ##  endRow = 69517    ## 2007-02-02

  ## Grab the headers
  power_head <- read.table(filename, sep = ";", header = T,
                           colClasses = c("character","character","numeric","numeric"
                                          ,"numeric","numeric","numeric","numeric", "numeric"),
                           na.strings = "?", nrows = 1);

  ## Grab only the lines for 2007-02-01 and 2007-02-02 (lines 66638 to 69517)
  power_data <- read.table("household_power_consumption.txt", sep = ";", header = F,
                           colClasses = c("character","character","numeric","numeric"
                                          ,"numeric","numeric","numeric","numeric", "numeric"),
                           na.strings = "?", nrows = endRow - startRow + 1, skip = startRow - 1);

  ## Assign names and drop header object
  names(power_data) <- names(power_head);
  rm(power_head);

  ## Convert the date and time
  power_data <- power_data %>%
    mutate(dateTime = parse_date_time(paste(Date, Time, sep = " "), "%d%m%Y %H%M%S")) %>%
    select(dateTime, 3:10);

  power_data
}

## Run importData to pull in power data into power_data
## Comment this line out for testing purposes to avoid constant reads of the file
power_data <- importData();

## Switch to a .png file device
png(file = "plot3.png");

par(mfrow = c(1,1));

with(power_data, {
  plot(dateTime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "");
    lines(dateTime, Sub_metering_2, type = "l", col = "red");
    lines(dateTime, Sub_metering_3, type = "l", col = "blue");
    legend("topright",
           lty=c(1,1,1), lwd=c(1,1,1),
           col = c("black","red","blue"),
           legend = names(power_data)[6:8]);
  });


## close .png device
dev.off();
