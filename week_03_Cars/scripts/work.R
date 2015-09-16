data <- read.csv("C:/Users/Patrick/OneDrive/R_Projects/10_Weeks/week_03_Cars/data/car_data.csv", header=FALSE)
cols <- read.csv("C:/Users/Patrick/OneDrive/R_Projects/10_Weeks/week_03_Cars/data/cols.txt", sep="", stringsAsFactors=FALSE)
colnames(data) <- cols$value
data$acceptable <- as.factor(ifelse(data$acceptable == "unacc", 0, 1))
rm(cols)


# create test and training sets 
inTrain <- sample(1:nrow(data), nrow(data) * 0.85) # select 85% of the items 
train <- data[inTrain, ]
test <- data[-inTrain, ]
rm(data, inTrain)

# Lets start with a standard glm 
model <- glm(train$acceptable ~ ., data=train, family=binomial(link="logit"))
predicted <- predict(model, test, type=c("response" ))
results <- as.data.frame(cbind(test$acceptable, predicted))
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



