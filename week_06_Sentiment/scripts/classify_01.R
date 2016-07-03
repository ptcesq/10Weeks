# set seed 
set.seed(6678)

spam <- readRDS('./data/clean_data.RDS')
spam$target <- as.factor(spam$target)
spam <- spam[,-c(1,3)]



# create test and training sets 
inTrain <- sample(1:nrow(spam), nrow(spam) * 0.85) # select 85% of the items 
train <- spam[inTrain, ]
test <- spam[-inTrain, ]
rm(spam, inTrain)

# Lets start with a standard glm 
model <- glm(train$target ~ ., data=train, family=binomial(link="logit"))
predicted <- predict(model, test, type=c("response" ))
results <- as.data.frame(cbind(test$target, predicted))
colnames(results) <- c("actual", "odds")
results$pred <- ifelse(results$odds < 0.5, 0, 1)
results$actual <- ifelse(results$actual == 2, 1, 0)

# Contingency Table 
library(gmodels)
with(results, CrossTable(actual, pred, prop.chisq=FALSE, 
                         prop.r=FALSE, prop.c=FALSE, prop.t=FALSE, 
                         format="SPSS"))


library(ROCR)
# precision recall graph 
pred <- prediction(results$pred, results$actual)


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
with(results, CrossTable(actual, pred))
with(results, CrossTable(pred, actual, prop.chisq=FALSE, 
                         prop.r=FALSE, prop.c=FALSE, prop.t=FALSE, 
                         format="SPSS"))










