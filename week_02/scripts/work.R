
# Load data into system 
spam <- read.csv("C:/Users/Patrick/OneDrive/R_Projects/10_Weeks/week_02/data/spambase.data", header=FALSE)

# add column names 
cols <- read.table("C:/Users/Patrick/OneDrive/R_Projects/10_Weeks/week_02/data/cols.txt", quote="\"", stringsAsFactors=FALSE)
colnames(spam) <- cols$V1

