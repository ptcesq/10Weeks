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

saveRDS(df, "./data/labeled_obs.RDS")
