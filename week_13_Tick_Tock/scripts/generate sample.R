
## read in date/time info in format 'm/d/y h:m:s'
dates <- c("06/06/2016", "06/07/2016", "06/08/2016", "06/09/2016", "06/10/2016")
times <- c("08:00:00", "08:00:00", "08:00:00", "08:00:00", "08:00:00")
x <- paste(dates, times)
 d <- strptime(x, "%m/%d/%Y %H:%M:%S")

n = 100
t1 <- do.call("rbind", replicate(n, d, simplify = FALSE))
t1 <- as.data.frame(t1)



e <- data.frame(employee = c('a', 'b', 'c', 'd', 'e'))
n = 100
t2 <- do.call("rbind", replicate(n, e, simplify = FALSE))

t3 <- cbind(t1, t2)
