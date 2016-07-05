
d <- data.frame(date = c('6-6-16', '6-7-16', '6-8-16', '6-9-16', '6-10-16'))
n = 100
t1 <- do.call("rbind", replicate(n, d, simplify = FALSE))

e <- data.frame(employee = c('a', 'b', 'c', 'd', 'e'))
n = 100
t2 <- do.call("rbind", replicate(n, e, simplify = FALSE))

t3 <- cbind(t1, t2)