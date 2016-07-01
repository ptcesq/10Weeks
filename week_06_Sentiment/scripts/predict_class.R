
df <- readRDS('./data/clean_data.RDS')
df$target <- as.factor(df$target)
df <- df[,-c(1,3)]


# split into train and test 
inTrain <- sample(1:nrow(df), nrow(df)*0.8)
train <- df[inTrain,]
test <- df[-inTrain,]

mylogit <- glm(target~., data=train, family = 'binomial')

