latemail <- function(N, st="2012/01/01", et="2012/12/31") {
       st <- as.POSIXct(as.Date(st))
       et <- as.POSIXct(as.Date(et))
       dt <- as.numeric(difftime(et,st,unit="sec"))
       ev <- sort(runif(N, 0, dt))
       rt <- st + ev
}