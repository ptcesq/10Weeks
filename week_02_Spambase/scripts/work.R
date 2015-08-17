# set seed 
set.seed(6678)


# Load data into system 
spam <- read.csv("./data/spambase.data", header=FALSE)

# add column names 
cols <- read.table("./data/cols.txt", quote="\"", stringsAsFactors=FALSE)
colnames(spam) <- cols$V1
rm(cols)
# spam$class <- factor(spam$class, labels=c("spam", "ham"))


# create test and training sets 
inTrain <- sample(1:nrow(spam), nrow(spam) * 0.85) # select 85% of the items 
train <- spam[inTrain, ]
test <- spam[-inTrain, ]
rm(spam, inTrain)

# Lets start with a standard glm 
model <- glm(train$class ~ ., data=train, family=binomial(link="logit"))
predicted <- predict(model, test, type=c("response" ))
results <- as.data.frame(cbind(test$class, predicted))
colnames(results) <- c("actual", "odds")
results$pred <- ifelse(results$odds < 0.5, 0, 1)



library(ROCR)
# precision recall graph 
<<<<<<< HEAD
pred <- prediction(results$actual, results$pred)
=======
pred <- prediction(results$pred, results$actual)
>>>>>>> 9c901e741a6a380e30a72c8ba7709a0f5cbbfb52

## computing a simple ROC curve (x-axis: fpr, y-axis: tpr)
perf <- performance(pred,"tpr","fpr")
auc.perf <- performance(pred, measure="auc")
auc.perf@y.values
ROC.Val <- auc.perf@y.values
main.label <- paste("ROC Curve - AUC=", ROC.Val)
plot(perf, colorize=TRUE, main=main.label)
abline(a=0, b=1)


# Contingency Table 
library(gmodels)
<<<<<<< HEAD
with(results, CrossTable(actual, pred))
=======
with(results, CrossTable(pred, actual, prop.chisq=FALSE, 
                         prop.r=FALSE, prop.c=FALSE, prop.t=FALSE, 
                         format="SPSS"))
>>>>>>> 9c901e741a6a380e30a72c8ba7709a0f5cbbfb52















