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
power_data <- importData()

## Switch to a .png file device
png(file = "plot1.png");

par(mfrow = c(1,1));
hist(power_data$Global_active_power,
     main = "Global Active Power",
     col = "red",
     xlab = "Global Active Power (kilowatts)");

## close .png device
dev.off()