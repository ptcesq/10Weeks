# Load necessary Library 
library(ROCR)

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

# Create a result set with a standard glm 
model <- glm(train$class ~ ., data=train, family=binomial(link="logit"))
predicted <- predict(model, test, type=c("response" ))
results <- as.data.frame(cbind(test$class, predicted))
colnames(results) <- c("actual", "odds")
results$pred <- ifelse(results$odds < 0.5, 1, 2)

# precision recall graph 
pred <- prediction(results$pred, results$actual)

## computing a simple ROC curve (x-axis: fpr, y-axis: tpr)
perf <- performance(pred,"tpr","fpr")
auc.perf <- performance(pred, measure="auc")
auc.perf@y.values
ROC.Val <- auc.perf@y.values