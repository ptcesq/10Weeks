library(RWeka)
library(tm)

require(tm)
files <- DirSource(directory = "./data/text/",encoding ="latin1" )
corpus <- VCorpus(x=files)
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

matrix_terms <- DocumentTermMatrix(corpus)



inspect(matrix_terms[1:2,1:15])
