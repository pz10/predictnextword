require(tm)
require(stringi)
require(data.table)
require(quanteda)
require(ggplot2)
require(wordcloud)
require(microbenchmark)
require(caret)
################################################################################
source("customFunctions.R")
source("algorithm_nocandidate.R")
myStopWords <- fread("stopWords.txt")

# read ranked tables.
#       object CODING: m.(ngram).(skip).(stopword: "" or "S")
#       e.g. m.2.03.S: ngram=2, skip=0:3, stopword=TRUE (removed stopwords) 

folder.in <- "rankedTables"
m.2.0 <- fread( paste0(folder.in, "/2g_sk0.txt") )
m.3.0 <- fread( paste0(folder.in, "/3g_sk0.txt") )
m.4.0 <- fread( paste0(folder.in, "/4g_sk0.txt") )
# m.5.0 <- fread( paste0(folder.in, "/5g_sk0.txt") )
# m.6.0 <- fread( paste0(folder.in, "/6g_sk0.txt") )
# m.7.0 <- fread( paste0(folder.in, "/7g_sk0.txt") )

m.2.03.S <- fread( paste0(folder.in, "/2g_sk03_stopworded.txt") )
m.3.03.S <- fread( paste0(folder.in, "/3g_sk03_stopworded.txt") )
m.4.03.S <- fread( paste0(folder.in, "/4g_sk03_stopworded.txt") )

m.2.0.S <- fread( paste0(folder.in, "/2g_sk0_stopworded.txt") )
m.3.0.S <- fread( paste0(folder.in, "/3g_sk0_stopworded.txt") )
m.4.0.S <- fread( paste0(folder.in, "/4g_sk0_stopworded.txt") )


# splitn.gram into columns (atomizing the string)
m.2.0[,c("p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
m.3.0[,c("p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
m.4.0[,c("p.3" ,"p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
# m.5.0[,c("p.4" ,"p.3" ,"p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
# m.6.0[,c("p.5" ,"p.4" ,"p.3" ,"p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
# m.7.0[,c("p.6" ,"p.5" ,"p.4" ,"p.3" ,"p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]

m.2.03.S[,c("p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
m.3.03.S[,c("p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
m.4.03.S[,c("p.3" ,"p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]

m.2.0.S[,c("p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
m.3.0.S[,c("p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]
m.4.0.S[,c("p.3" ,"p.2" ,"p.1" , "p.0"):= tstrsplit(n.gram, " ", fixed=T)[]]

# set keys for fast subsetting (sorting, ranking, summarizing)
m.2.0[,freq := -freq]
m.3.0[,freq := -freq]
m.4.0[,freq := -freq]
# m.5.0[,freq := -freq]
# m.6.0[,freq := -freq]
# m.7.0[,freq := -freq]

m.2.03.S[,freq := -freq]
m.3.03.S[,freq := -freq]
m.4.03.S[,freq := -freq]

m.2.0.S[,freq := -freq]
m.3.0.S[,freq := -freq]
m.4.0.S[,freq := -freq]

setkey(m.2.0, freq, p.0, p.1)
setkey(m.3.0, freq, p.0, p.1, p.2)
setkey(m.4.0, freq, p.0, p.1, p.2, p.3)
# setkey(m.5.0, freq, p.0, p.1, p.2, p.3, p.4)
# setkey(m.6.0, freq, p.0, p.1, p.2, p.3, p.4, p.5)
# setkey(m.7.0, freq, p.0, p.1, p.2, p.3, p.4, p.5, p.6)

setkey(m.2.03.S, freq, p.0, p.1)
setkey(m.3.03.S, freq, p.0, p.1, p.2)
setkey(m.4.03.S, freq, p.0, p.1, p.2, p.3)

setkey(m.2.0.S, freq, p.0, p.1)
setkey(m.3.0.S, freq, p.0, p.1, p.2)
setkey(m.4.0.S, freq, p.0, p.1, p.2, p.3)
#################
### only for skip=0:3
### remove entries (lines) with duplicated words

# m.4.03.S
m.4.03.S[, id:= 1:.N]
setkey(m.4.03.S, id)
m.4.03.S[, uniques:= length(unique(c(p.1, p.2, p.3))), by = id]
m.4.03.S <- m.4.03.S[uniques==3]
m.4.03.S[, id:= NULL]
m.4.03.S[, uniques:= NULL]
setkey(m.4.03.S, freq, p.0, p.1, p.2, p.3)

# m.3.03.S
m.3.03.S[, id:= 1:.N]
setkey(m.3.03.S, id)
m.3.03.S[, uniques:= length(unique(c(p.1, p.2))), by = id]
m.3.03.S <- m.3.03.S[uniques==2]
m.3.03.S[, id:= NULL]
m.3.03.S[, uniques:= NULL]
setkey(m.3.03.S, freq, p.0, p.1, p.2)
