# Load the Libraries 
library(tm)

# Fetch the data 
df <- readRDS('./data/labeled_obs.RDS')

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

saveRDS(df, './data/clean_data.RDS')





