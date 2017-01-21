# Set Seed 
set.seed(1234)


# Windows Version 
data <- read.csv("./data/news.csv", header=TRUE)
cols <- read.csv("./data/cols.txt", header=TRUE, stringsAsFactors = FALSE)

colnames(data) <- cols$col_name

# rename target as target 
# Don't need to, done in this case. 
colnames(data)[61] <- "target"

#
# set threshold 
# or transform dicotomous 
# 
#
data$target <- as.factor(ifelse(data$target >= 1400, TRUE, FALSE))
rm(cols)

# 
# In this data set we need to remove the URL (adds nothing to the model and confuses it) 
# don't need in this case. 
#
# data <- subset(data, select = -c(url))



# create test and training sets 
inTrain <- sample(1:nrow(data), nrow(data) * 0.85) # select 85% of the items 
train <- data[inTrain, ]
test <- data[-inTrain, ]
rm(data, inTrain)

# Lets start with a standard glm 
model <- glm(train$target ~ ., data=train, family=binomial(link="logit"))
predicted <- predict(model, test, type=c("response" ))
results <- as.data.frame(cbind(test$target, predicted))
results$V1 <- ifelse(results$V1 == 1, 0, 1)
colnames(results) <- c("actual", "odds")
results$pred <- ifelse(results$odds < 0.5, 0, 1)


# Contingency Table 
library(gmodels)
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






