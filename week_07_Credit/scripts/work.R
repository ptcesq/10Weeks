# Set Seed 
set.seed(1234)

library(readr)
data <- read_delim("~/r_projects/10Weeks/week_07_Credit/data/german.csv",
                    " ", escape_double = FALSE, trim_ws = TRUE)

# Read in Column Names 
columns <- read.csv('./data/cols.txt')
colnames(data) <- columns$col_name

# Fetch Codes 
codes <- read.csv('./data/codes.txt')



# rename target as target 
colnames(data)[61] <- "target"

#
# set threshold 
# or transform dicotomous 
#
data$target <- as.factor(ifelse(data$target <= 1400, 0, 1))
rm(cols)

# 
# In this data set we need to remove the URL (adds nothing to the model and confuses it) 
#
data <- subset(data, select = -c(url))



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






