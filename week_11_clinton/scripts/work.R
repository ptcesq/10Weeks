# Libraries 
require(RSQLite)

# open your data base 
library(RSQLite)
setwd("D:/R_Projects/10Weeks/week_11_clinton")
db <- dbConnect(dbDriver("SQLite"), "./data/database.sqlite")


# Now select the extracted email bodies 
emailsFromHillary <- dbGetQuery(db, "
SELECT ExtractedBodyText FROM Emails")
print.table(head(emailsFromHillary))

head(emailsFromHillary)
library(RWeka)
library(tm)

require(tm)
corpus <- Corpus(VectorSource(emailsFromHillary))
summary(corpus)
corpus <- tm_map(corpus,content_transformer(removePunctuation))
corpus <- tm_map(corpus,content_transformer(stripWhitespace))
corpus <- tm_map(corpus,content_transformer(removePunctuation))
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- Corpus(VectorSource(corpus))

require(RWeka)
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
tdm <- TermDocumentMatrix(corpus, control = list(tokenize = TrigramTokenizer))
inspect(tdm)
