###############################################
#
#  Load Data and Set response variable to
#  a dicotimous result 
# 
###############################################

white <- read.csv("./data/winequality-white.csv", sep=";")
white$class <- as.factor(ifelse(white$quality <= 5, 0, 1))
summary(white)
white <- white[,-12]

################################################
#
#   Select Samples 
#
################################################

set.seed(1234)
in_train <- sample(1:nrow(white), nrow(white)*.8, replace = FALSE)
train <- white[in_train,]
test <- white[-in_train,]
remove(white, in_train)

###############################################
#
#   Train your model 
# 
###############################################

model <- glm(train$class ~ ., data=train, family=binomial(link="logit"))
predicted <- predict(model, test, type=c("response" ))
results <- as.data.frame(cbind(test$class, predicted))
colnames(results) <- c("actual", "odds")
results$pred <- ifelse(results$odds < 0.5, 0, 1)
results$actual <- ifelse(results$actual == 2, 1, 0)

##################################################
#
# Contingency Table
#
##################################################

library(gmodels)
with(results, CrossTable(actual, pred, prop.chisq=FALSE, 
                         prop.r=FALSE, prop.c=FALSE, prop.t=FALSE, 
                         format="SPSS"))

##################################################
#
#   Model Error Rate  
#
##################################################

err <- sum(ifelse(results$actual==results$pred, 1, 0))/nrow(test)
cat("Error: ", err)

##################################################
#
# AUC Graph 
#
##################################################

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

