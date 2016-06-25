library(randomForest)
data(fgl, package="MASS")
fgl.res <- tuneRF(fgl[,-10], fgl[,10], stepFactor=1.5, plot=TRUE, mtry=1000)
