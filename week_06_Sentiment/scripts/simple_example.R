texts <- c("foo bar spam",
           "bar baz ham",
           "baz qux spam",
           "qux quux ham")

categories <- c("Spam", "Ham", "Spam", "Ham")

new <- "quux quuux ham"

### II) Building Model on Existing Documents „texts“

library(tm)  # text mining package for R
library(e1071)  # package with various machine-learning libraries

## creating DTM for texts
dtm <- DocumentTermMatrix(Corpus(VectorSource(texts)))

## making DTM a data.frame and adding variable categories
df <- data.frame(categories, as.data.frame(inspect(dtm)))

model <- svm(categories~., data=df)

### III) Predicting class of new

## creating dtm for new
dtm_n <- DocumentTermMatrix(Corpus(VectorSource(new)),
                            ## without this line predict won't work
                            control=list(dictionary=names(df)))
## creating data.frame for new
df_n <- as.data.frame(inspect(dtm_n))

predict(model, df_n)

## > 1 
## > Ham 
## > Levels: Ham Spam