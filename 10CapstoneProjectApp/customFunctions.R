# NOT in operator: opposite as '%in%' operator
'%!in%' <- function(x,y)!('%in%'(x,y))

################################################################################
# expand a data set (i.e. containing a text documenet on each row) so that every row contains an individual sentence
get.Ngram <- function(input.file, output.file, 
                      Ngram, skip =0, stopWords = FALSE,
                      concatenator = " ",
                      delete.rare = 0, output.limit = 300000,
                      linesPerLoop = 10000){
        ##################
        # ARGUMENTS:
        
        # input.file --> path file to the data (text document on each row)
        # output.file --> a file with a text document on each row
        # Ngram --> a single integer (e.g. 1:3 is NOT implemented)
        # skip --> as in quanted::tokens (e.g. 1:3 is implemented)
        # stopwords --> should stopwords be removed before tokenization? (see quanteda::stopwords)
        # concatenator --> as in quanteda::tokens
        # delete.rare --> an integer. Features with a frequency (i.e. counts per iteration) <= this valueare discarded
        #                       avoids long objects
        # output.limit --> line limit of the output object. To prevent memory issues
        # linesPerLoop --> approx. number of lines to be processed in each loop. Reduce it if memory issues occur.
        ##################
        mytime1 <- Sys.time()
        
        data <- readLines(input.file, encoding = "UTF-8", skipNul = TRUE)
        loops <- floor(length(data)/linesPerLoop)
        loop.load <- floor(length(data)/loops)
        my.skip <- 0
        
        for(i in 1:loops){
                # read text documents
                data.i <- data[(my.skip+1) : (my.skip+loop.load)]
                
                # get individual sentences on each row
                token.sentence <- tokens(data.i, what = "sentence")
                token.sentence <- char_tolower(token.sentence)
                
                
                # create a n-grams (without or with removal of stopwords)
                if(stopWords == FALSE){
                        token.Ngram <- tokens(token.sentence, ngrams = Ngram, skip=skip,
                                              concatenator = concatenator,
                                              removeNumbers = TRUE, removePunct = TRUE,
                                              removeSymbols = TRUE, removeTwitter = TRUE,
                                              removeURL = TRUE)
                        
                }else if(stopWords == TRUE){
                        token.sentence <- removeFeatures(
                                tokens(token.sentence,
                                       ngrams = 1L, skip=0L,
                                       concatenator = concatenator,
                                       removeNumbers = TRUE, removePunct = FALSE,
                                       removeSymbols = TRUE, removeTwitter = TRUE,
                                       removeURL = TRUE)
                                , stopwords("english")
                        )
                        token.Ngram <- tokens_ngrams(token.sentence, n = Ngram, skip=skip,
                                                     concatenator = concatenator)  
                }
                rm(token.sentence)
                token.Ngram <- char_tolower(token.Ngram)
                
                # manipulate N-gram
                token.Ngram <- data.table(n.gram = token.Ngram)
                setkey(token.Ngram, n.gram)
                
                #       1. get unique N-grams and their frequencies
                token.Ngram <- token.Ngram[, .(freq = .N), by=n.gram]
                
                #       2. remove numbers, punctuation (not everything was removed before)
                token.Ngram[, is.word := !stringr::str_detect(n.gram, pattern = "[^A-z ]")]
                token.Ngram[, is.punct := stringr::str_detect(n.gram, pattern = "[[:punct:]]")]
                token.Ngram <- token.Ngram[is.word==T & is.punct==F]
                token.Ngram[, is.word:=NULL]
                token.Ngram[, is.punct:=NULL]
                
                #       3. remove long strings (and low frquencies if desired)
                token.Ngram[,nchars:= nchar(n.gram)]
                nchar.limit <- quantile(token.Ngram[freq>1,nchars], probs=c(0.99))[[1]] #*1.3
                token.Ngram[, freq := -freq]
                setkey(token.Ngram, freq); token.Ngram[, freq := -freq]
                
                token.Ngram <- token.Ngram[nchars<=nchar.limit & freq > delete.rare] # delete freq<1 (del.rare =1)?
                token.Ngram[, nchars:=NULL]
                if(nrow(token.Ngram)>output.limit){ #limit object size
                        freq.limit <- token.Ngram[output.limit, freq]
                        token.Ngram <- token.Ngram[freq >  freq.limit]
                }
                
                # store N-gram from this loop. Merge it with that form previous
                if(i==1){
                        ngram.N <- copy(token.Ngram)
                }else{
                        ngram.N <- rbindlist(list(ngram.N, token.Ngram))
                        setkey(ngram.N, n.gram)
                        ngram.N <- ngram.N[, .( freq = sum(freq) ), by=n.gram]
                        
                        # limit object size
                        ngram.N[, freq := -freq]
                        setkey(ngram.N, freq); ngram.N[, freq := -freq]
                        if(nrow(ngram.N)>output.limit){
                                freq.limit <- ngram.N[output.limit, freq]
                                ngram.N <- ngram.N[freq >  freq.limit]
                        }
                }
                
                my.skip <- my.skip + loop.load
                print (paste(floor(100*i/loops), "% "))
        }
        
        # write output file
        ngram.N[,freq:=-freq]
        setkey(ngram.N, freq)
        ngram.N[,freq:=-freq]
        
        cat ("writing output to : ", output.file)
        write.table(ngram.N, output.file, fileEncoding = "UTF-8",
                    row.names = F, col.names = T, sep = "\t", quote = FALSE)
        
        print(Sys.time())
        mytime2 <- Sys.time()
        cat("elapsed time:", difftime(mytime2, mytime1, units = "mins"), "minutes")
}
################################################################################
get.tokens <- function(string, Ngram, skip =0, stopWords = TRUE,
                       concatenator = " "){
        
        
        my.tokens <- removeFeatures(
                tokens(string,
                       ngrams = 1L, skip=0L,
                       concatenator = concatenator,
                       removeNumbers = TRUE, removePunct = FALSE,
                       removeSymbols = TRUE, removeTwitter = TRUE,
                       removeURL = TRUE)
                , stopwords("english")
        )
        my.tokens <- rev(my.tokens[[1]])
        
        bounds <- last(skip)*(Ngram-1)+Ngram
        my.tokens <- my.tokens[1:bounds]
        my.tokens <- my.tokens[!is.na(my.tokens)]

        return(my.tokens)
}