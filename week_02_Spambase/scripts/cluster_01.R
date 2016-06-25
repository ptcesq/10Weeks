# Load necessary Library 
library(ROCR)
library(EMCluster)

# set seed 
set.seed(6678)

# Load data into system 
spam <- read.csv("./data/spambase.data", header=FALSE)

# add column names 
cols <- read.table("./data/cols.txt", quote="\"", stringsAsFactors=FALSE)
colnames(spam) <- cols$V1
rm(cols)
spam$class <- factor(spam$class, labels=c("spam", "ham"))

# create test and training sets 
inTrain <- sample(1:nrow(spam), nrow(spam) * 0.85) # select 85% of the items 
train <- spam[inTrain, ]
test <- spam[-inTrain, ]
rm(spam, inTrain)

library(cluster)
mod1 = fanny(train, 2)
plot(mod1)

