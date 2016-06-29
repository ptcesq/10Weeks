library(tm)
library(stringi)
library(proxy)
wiki <- "http://en.wikipedia.org/wiki/"
titles <- c("Integral", "Riemann_integral", "Riemann-Stieltjes_integral", "Derivative",
            "Limit_of_a_sequence", "Edvard_Munch", "Vincent_van_Gogh", "Jan_Matejko",
            "Lev_Tolstoj", "Franz_Kafka", "J._R._R._Tolkien")
articles <- character(length(titles))

for (i in 1:length(titles)) {
  articles[i] <- stri_flatten(readLines(stri_paste(wiki, titles[i])), col = " ")
}

docs <- Corpus(VectorSource(articles))


docs[[1]]

docs2 <- tm_map(docs, function(x) stri_replace_all_regex(x, "<.+?>", " "))
docs3 <- tm_map(docs2, function(x) stri_replace_all_fixed(x, "\t", " "))

docs4 <- tm_map(docs3, PlainTextDocument)
docs5 <- tm_map(docs4, stripWhitespace)
docs6 <- tm_map(docs5, removeWords, stopwords("english"))
docs7 <- tm_map(docs6, removePunctuation)
docs8 <- tm_map(docs7, tolower)

docs8[[1]]

docs8 <- tm_map(docs8, PlainTextDocument)

docsTDM <- TermDocumentMatrix(docs8)

library(bigmemory)
DTM=t(docsTDM)
M=as.big.matrix(x=as.matrix(DTM))
M=as.matrix(M)
M=t(M)

docsdissim <- dist(M)

docsdissim2 <- as.matrix(docsdissim)
rownames(docsdissim2) <- titles
colnames(docsdissim2) <- titles
docsdissim2
h <- hclust(docsdissim, method = "ward")


