# Munge data 
# set working directory 
setwd("D:/R_Projects/10Weeks/week_06_Sentiment")

# load data
imdb_labelled <- read.delim("./data/imdb_labelled.txt", header=FALSE, stringsAsFactors=FALSE)
yelp_labelled <- read.delim("./data/yelp_labelled.txt", header=FALSE, stringsAsFactors=FALSE)
amazon_cells_labelled <- read.delim("./data/amazon_cells_labelled.txt", stringsAsFactors=FALSE)

df1 <- amazon_cells_labelled[complete.cases(amazon_cells_labelled), ]
df2 <- imdb_labelled[complete.cases(imdb_labelled), ]
df3 <- yelp_labelled[complete.cases(yelp_labelled), ]

colnames(df1) <- c('text', 'target')
colnames(df2) <- c('text', 'target')
colnames(df3) <- c('text', 'target')

df <- rbind(df1, df2, df1)

# Load the Libraries 
library(tm)

# make your corpus 
input <- df$text
vSOurce <- VectorSource(input)
df.Corpus <- Corpus(vSOurce)

# clean your corpus 
# put everythin in lower case
df.Corpus <- tm_map(df.Corpus, content_transformer(tolower))
# remove anything other than English letters or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
df.Corpus <- tm_map(df.Corpus, content_transformer(removeNumPunct))
# remove punctuation
df.Corpus <- tm_map(df.Corpus, removePunctuation)
# remove numbers
df.Corpus <- tm_map(df.Corpus, removeNumbers)
# add two extra stop words: "available" and "via"
df.Stopwords <- c(stopwords('english'), 'LOL')
# remove "r" and "big" from stopwords
df.Stopwords <- setdiff(df.Stopwords, c("LOL"))
# remove stopwords from corpus
df.Corpus <- tm_map(df.Corpus, removeWords, df.Stopwords)
# remove extra whitespace
df.Corpus <- tm_map(df.Corpus, stripWhitespace)
df.Corpus <- tm_map(df.Corpus, PlainTextDocument)

# creat the matrix 
dtm <- DocumentTermMatrix(df.Corpus)
# reformat it 
dtm_matrix <- as.matrix(dtm) 

t1 <- colSums(dtm_matrix)

keepers <- which(t1>5)
keepers <- sort(keepers, decreasing = TRUE)
keepers <- keepers[1:50]
dtm_matrix <- dtm_matrix[,keepers]

df <- cbind(df, dtm_matrix)


# set seed 
set.seed(6678)

spam <- df
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


