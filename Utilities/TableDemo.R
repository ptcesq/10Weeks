

actual <- c(1,1,1,1,1,1,0,0,0,0)
pred <- c(1,1,1,1,1,1,1,1,0,0)
results <- cbind(actual, pred)
results <- as.data.frame(results)


library(gmodels)

with(results, CrossTable(actual, pred, prop.chisq=FALSE, 
                         prop.r=FALSE, prop.c=FALSE, prop.t=FALSE, 
                         format="SAS"))
