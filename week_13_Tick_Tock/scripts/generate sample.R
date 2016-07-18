# generate a sample of time cards, with variation 
n = 1000 

base_date <- c("20081101", "20081101", "20081101", "20081101", "20081101", "20081102", 
           "20081102", "20081102", "20081102", "20081103")
base_dates <- rep(base_date, n/length(base_date))


base_time <- "08:00:00"
base_times <- rep(base_time, n)

library(randomNames)
base_name <- randomNames(n/length(base_date))
base_names <- rep(base_name, n/length(base_date))

df <- as.data.frame(cbind(base_dates, base_times, base_names))

df$date <- paste(df$base_dates, df$base_times)

df$date <- as.POSIXct(df$date, format = "%Y%m%d %H:%M:%S")
df <- df[,-c(1:2)]

df$date <- df$date + sample(-600:600,n, replace = TRUE)
