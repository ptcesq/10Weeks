# Clean up data with the TM package 

df <- readRDS('./data/labeled_obs.RDS')

library(tm)

df.Corpus <- Corpus(VectorSource(df$text))
df.target <- df$target

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

# a little cleaning first, take out all empy slots 
df3 <- data.frame(text=sapply(df.Corpus, `[[`, "content"), stringsAsFactors=FALSE)
# reattach the classification 
df3$target <- df.target

# now take out all of the blank rows 
df3 <- subset(df3, text!=" ")

# add and ID to each record 
df3$id <- seq(1,nrow(df3))

df.Reader <- readTabular(mapping=list(content="text", target="target", id="id"))
tm <- VCorpus(DataframeSource(df3), readerControl=list(reader=df.Reader))

dtm <- DocumentTermMatrix(tm, control=list(weighting=weightTfIdf, minWordLength=2, minDocFreq=5))

removeSparseTerms(dtm, 0.2)

