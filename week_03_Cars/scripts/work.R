# Cars df Set - Logistic Analysis 
#

df <- read.csv("./data/car_data.csv", header=FALSE)
colnames(df) <- c("buying", "maint", "doors", "persons", "lug_boot", "safety", "target")
df$target <- as.factor(ifelse(df$target == "unacc", 0, 1))

# create test and training sets 
inTrain <- sample(1:nrow(df), nrow(df) * 0.85) # select 85% of the items 
train <- df[inTrain, ]
test <- df[-inTrain, ]
rm(df, inTrain)

# Lets start with a standard glm 
model <- glm(train$target ~ ., data=train, family=binomial(link="logit"))
predicted <- predict(model, test, type=c("response" ))
results <- as.data.frame(cbind(test$target, predicted))
results$V1 <- ifelse(results$V1 == 1, 0, 1)
colnames(results) <- c("actual", "odds")
results$pred <- ifelse(results$odds < 0.5, 0, 1)


# Contingency Table 
library(gmodels)
with(results, CrossTable(actual, pred))
with(results, CrossTable(pred, actual, prop.chisq=FALSE, 
                         prop.r=FALSE, prop.c=FALSE, prop.t=FALSE, 
                         format="SPSS"))

library(ROCR)
# precision recall graph 
pred <- prediction(results$pred, results$actual)


## computing a simple ROC curve (x-axis: fpr, y-axis: tpr)
perf <- performance(pred,"tpr","fpr")
auc.perf <- performance(pred, measure="auc")
print(paste('Accuracy:', auc.perf@y.values))
ROC.Val <- auc.perf@y.values
main.label <- paste("ROC Curve - AUC=", ROC.Val)
plot(perf, colorize=TRUE, main=main.label)
abline(a=0, b=1)


