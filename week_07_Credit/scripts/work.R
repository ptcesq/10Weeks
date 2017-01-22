# Set Seed 
set.seed(1234)

# read the data 
data <- read.csv('./data/german.csv', stringsAsFactors = FALSE, 
                 sep=' ', header = FALSE)

# Read in Column Names 
columns <- read.csv('./data/cols.txt', stringsAsFactors = FALSE)
colnames(data) <- trimws(columns$col_name)

codes <- read.csv('./data/codes.txt', stringsAsFactors = FALSE)
codes[,2] <- trimws(codes[,2])

# Replace Codes 
for (i in 1:nrow(codes)){
  current_col = codes[i, 1]
  current_code = codes[i, 2]
  current_replace = codes[i, 3]
  data[, current_col] <- gsub(current_code, current_replace, data[,current_col])
}

factor_cols <- unique(codes[,1])
for (cur_col in factor_cols){
  data[, cur_col] <- as.factor(data[,cur_col])
}

data$target <- ifelse(data$target == 1, TRUE, FALSE)
data$target <- as.factor(data$target)

# Clean up the workspace 
rm(codes, columns, cur_col, 
   current_code, current_replace, 
   factor_cols, i, current_col)

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
print(paste('Accuracy: ', auc.perf@y.values))
ROC.Val <- auc.perf@y.values
main.label <- paste("ROC Curve - AUC=", ROC.Val)
plot(perf, colorize=TRUE, main=main.label)
abline(a=0, b=1)






