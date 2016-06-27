# Clean up data with the TM package 

df <- readRDS('./data/labeled_obs.RDS')

library(tm)

df.Corpus <- Corpus(VectorSource(df$text))

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

saveRDS(df.Corpus, './data/df.Corpus.RDS')
