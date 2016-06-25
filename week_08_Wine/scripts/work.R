###############################################
#
#  Load Data and Set response variable to
#  a dicotimous result 
# 
###############################################

pop <- read.csv("./data/winequality-white.csv", sep=";")
pop$class <- as.factor(ifelse(pop$quality <= 5, 0, 1))
summary(pop)
pop <- pop[,-12]  # modify this to remove original dependent variable 

################################################
#
#   Select Samples 
#
################################################

options(digits=4)
set.seed(1234)
in_train <- sample(1:nrow(pop), nrow(pop)*.8, replace = FALSE)
train <- pop[in_train,]
test <- pop[-in_train,]
remove(pop, in_train)

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

main.label <- paste("ROC Curve - AUC=", ROC.Val, " Err: ", err)
plot(perf, colorize=TRUE, main=main.label)
abline(a=0, b=1)

