# set seed 
set.seed(1234)


# Load data into system 
spam <- read.csv("./data/spambase.data", header=FALSE)

# add column names 
cols <- read.table("./data/cols.txt", quote="\"", stringsAsFactors=FALSE)
colnames(spam) <- cols$V1
rm(cols)
spam$ans <- factor(spam$class, labels=c("spam", "ham"))


# create test and training sets 
inTrain <- sample(1:nrow(spam), nrow(spam) * 0.85) # select 85% of the items 
train <- spam[inTrain, ]
test <- spam[-inTrain, ]
rm(spam, inTrain)

# Lets start with a standard glm 
model <- glm(train$spam ~ ., data=train, family=binomial(link="logit"))
predicted <- predict(model, test, "response" )
results <- as.data.frame(cbind(test$spam, predicted))
colnames(results) <- c("actual", "predicted")

library(ROCR)
# precision recall graph 
pred <- prediction(results$predicted, results$actual)

## computing a simple ROC curve (x-axis: fpr, y-axis: tpr)
perf <- performance(pred,"tpr","fpr")
auc.perf <- performance(pred, measure="auc")
auc.perf@y.values
ROC.Val <- auc.perf@y.values
main.label <- paste("ROC Curve - AUC=", ROC.Val)
plot(perf, colorize=TRUE, main=main.label)
abline(a=0, b=1)

## precision/recall curve (x-axis: recall, y-axis: precision)
perf1 <- performance(pred, "prec", "rec")
plot(perf1)

## sensitivity/specificity curve (x-axis: specificity,
## y-axis: sensitivity)
perf2 <- performance(pred, "sens", "spec")
plot(perf2)












