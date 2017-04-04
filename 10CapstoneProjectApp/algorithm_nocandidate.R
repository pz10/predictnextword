get.ranks <- function(string, show =5){
        tokens <- strsplit(string, "\\s+")[[1]]
        tokens <- rev(tokens)
        
        tokens.2.03.sw <- get.tokens(string, Ngram = 2, skip =0:3, stopWords = TRUE)
        tokens.3.03.sw <- get.tokens(string, Ngram = 3, skip =0:3, stopWords = TRUE)
        tokens.4.03.sw <- get.tokens(string, Ngram = 4, skip =0:3, stopWords = TRUE)
        
        tokens.2.0.sw <- get.tokens(string, Ngram = 2, skip =0, stopWords = TRUE)
        tokens.3.0.sw <- get.tokens(string, Ngram = 3, skip =0, stopWords = TRUE)
        tokens.4.0.sw <- get.tokens(string, Ngram = 4, skip =0, stopWords = TRUE)
        
        # I feel lazy
        
        # ########################################################################
        # # m.7.0
        # m.7.0[, rank:= as.numeric(0)]
        # m.7.0[p.1 == tokens[1],  rank:= rank-1]
        # m.7.0[p.2 == tokens[2],  rank:= rank-1]
        # m.7.0[p.3 == tokens[3],  rank:= rank-1]
        # m.7.0[p.4 == tokens[4],  rank:= rank-1]
        # m.7.0[p.5 == tokens[5],  rank:= rank-1]
        # m.7.0[p.6 == tokens[6],  rank:= rank-1]
        # 
        # setkey(m.7.0, rank, freq)
        # pred.7.0 <- m.7.0[rank==min(rank), .(rank = rank -1 + 7, Ngram.model = -7, Ngram.submodel = "01.normal", freq = freq, prediction = p.0)]
        # pred.7.0[,prob:= freq/sum(freq)] 
        # pred.7.0 <- pred.7.0[rank>=0,]
        # 
        # ##################
        # # m.6.0
        # m.6.0[, rank:= as.numeric(0)]
        # m.6.0[p.1 == tokens[1],  rank:= rank-1]
        # m.6.0[p.2 == tokens[2],  rank:= rank-1]
        # m.6.0[p.3 == tokens[3],  rank:= rank-1]
        # m.6.0[p.4 == tokens[4],  rank:= rank-1]
        # m.6.0[p.5 == tokens[5],  rank:= rank-1]
        # 
        # setkey(m.6.0, rank, freq)
        # pred.6.0 <- m.6.0[rank==min(rank), .(rank = rank -1 + 6, Ngram.model = -6, Ngram.submodel = "01.normal", freq = freq, prediction = p.0)]
        # pred.6.0[,prob:= freq/sum(freq)]  
        # pred.6.0 <- pred.6.0[rank>=0,]      
        # ##################
        # # m.5.0
        # m.5.0[, rank:= as.numeric(0)]
        # m.5.0[p.1 == tokens[1],  rank:= rank-1]
        # m.5.0[p.2 == tokens[2],  rank:= rank-1]
        # m.5.0[p.3 == tokens[3],  rank:= rank-1]
        # m.5.0[p.4 == tokens[4],  rank:= rank-1]
        # 
        # setkey(m.5.0, rank, freq)
        # pred.5.0 <- m.5.0[rank==min(rank), .(rank = rank -1 + 5, Ngram.model = -5, Ngram.submodel = "01.normal", freq = freq, prediction = p.0)]
        # pred.5.0[,prob:= freq/sum(freq)]  
        # pred.5.0 <- pred.5.0[rank>=0,]
        
        ##################
        # m.4.0
        m.4.0[, rank:= as.numeric(0)]
        m.4.0[p.1 == tokens[1],  rank:= rank-1]
        m.4.0[p.2 == tokens[2],  rank:= rank-1]
        m.4.0[p.3 == tokens[3],  rank:= rank-1]
        
        setkey(m.4.0, rank, freq)
        pred.4.0 <- m.4.0[rank==min(rank), .(rank = rank -1 + 4, Ngram.model = -4, Ngram.submodel = "01.normal", freq = freq, prediction = p.0)]
        pred.4.0[,prob:= freq/sum(freq)]  
        pred.4.0 <- pred.4.0[rank>=0,]
        
        ##################
        # m.3.0
        m.3.0[, rank:= as.numeric(0)]
        m.3.0[p.1 == tokens[1],  rank:= rank-1]
        m.3.0[p.2 == tokens[2],  rank:= rank-1]
        
        setkey(m.3.0, rank, freq)
        pred.3.0 <- m.3.0[rank==min(rank), .(rank = rank -1 + 3, Ngram.model = -3, Ngram.submodel = "01.normal", freq = freq, prediction = p.0)]
        pred.3.0[,prob:= freq/sum(freq)] 
        pred.3.0 <- pred.3.0[rank>=0,]
        
        ##################
        # m.2.0
        m.2.0[, rank:= as.numeric(0)]
        m.2.0[p.1 == tokens[1],  rank:= rank-1]
        
        setkey(m.2.0, rank, freq)
        pred.2.0 <- m.2.0[rank==min(rank), .(rank = rank -1 + 2, Ngram.model = -2, Ngram.submodel = "01.normal", freq = freq, prediction = p.0)]
        pred.2.0[,prob:= freq/sum(freq)]  
        pred.2.0 <- pred.2.0[rank>=0,]
        
        ########################################################################
        ##################
        # m.4.03.S
        m.4.03.S[, rank:= as.numeric(0)]
        m.4.03.S[p.1 %in% tokens.4.03.sw,  rank:= rank-1]
        m.4.03.S[p.2 %in% tokens.4.03.sw,  rank:= rank-1]
        m.4.03.S[p.3 %in% tokens.4.03.sw,  rank:= rank-1]
        # m.4.03.S[, id:= 1:.N]
        # setkey(m.4.03.S, id)
        # uniques <- function(x){length(stri_unique(x))}
        # m.4.03.S[, uniques:= uniques(n.gram), by=id]
        # 
        # m.4.03.S[, uniques:= length(unique(c(p.1, p.2, p.3))), by = id]
        
        setkey(m.4.03.S, rank, freq)
        pred.4.03.S <- m.4.03.S[rank==min(rank), .(rank = rank -1 + 4, Ngram.model = -4, Ngram.submodel = "03.skip03.sw", freq = freq, prediction = p.0)]
        pred.4.03.S[,prob:= freq/sum(freq)] 
        pred.4.03.S <- pred.4.03.S[rank>=0,]
        
        ##################
        # m.3.03.S
        m.3.03.S[, rank:= as.numeric(0)]
        m.3.03.S[p.1 %in% tokens.3.03.sw,  rank:= rank-1]
        m.3.03.S[p.2 %in% tokens.3.03.sw,  rank:= rank-1]
        
        setkey(m.3.03.S, rank, freq)
        pred.3.03.S <- m.3.03.S[rank==min(rank), .(rank = rank -1 + 3, Ngram.model = -3, Ngram.submodel = "03.skip03.sw", freq = freq, prediction = p.0)]
        pred.3.03.S[,prob:= freq/sum(freq)] 
        pred.3.03.S <- pred.3.03.S[rank>=0,]
        
        ##################
        # m.2.03.S
        m.2.03.S[, rank:= as.numeric(0)]
        m.2.03.S[p.1 %in% tokens.2.03.sw,  rank:= rank-1]
        
        setkey(m.2.03.S, rank, freq)
        pred.2.03.S <- m.2.03.S[rank==min(rank), .(rank = rank -1 + 2, Ngram.model = -2, Ngram.submodel = "03.skip03.sw", freq = freq, prediction = p.0)]
        pred.2.03.S[,prob:= freq/sum(freq)]
        pred.2.03.S <- pred.2.03.S[rank>=0,]
        ########################################################################
        ##################
        # m.4.0.S
        m.4.0.S[, rank:= as.numeric(0)]
        m.4.0.S[p.1 %in% tokens.4.0.sw,  rank:= rank-1]
        m.4.0.S[p.2 %in% tokens.4.0.sw,  rank:= rank-1]
        m.4.0.S[p.3 %in% tokens.4.0.sw,  rank:= rank-1]
        
        setkey(m.4.0.S, rank, freq)
        pred.4.0.S <- m.4.0.S[rank==min(rank), .(rank = rank -1 + 4, Ngram.model = -4, Ngram.submodel = "02.sw", freq = freq, prediction = p.0)]
        pred.4.0.S[,prob:= freq/sum(freq)]
        pred.4.0.S <- pred.4.0.S[rank>=0,]
        
        ##################
        # m.3.0.S
        m.3.0.S[, rank:= as.numeric(0)]
        m.3.0.S[p.1 %in% tokens.3.0.sw,  rank:= rank-1]
        m.3.0.S[p.2 %in% tokens.3.0.sw,  rank:= rank-1]
        
        setkey(m.3.0.S, rank, freq)
        pred.3.0.S <- m.3.0.S[rank==min(rank), .(rank = rank -1 + 3, Ngram.model = -3, Ngram.submodel = "02.sw", freq = freq, prediction = p.0)]
        pred.3.0.S[,prob:= freq/sum(freq)]
        pred.3.0.S <- pred.3.0.S[rank>=0,]
        
        ##################
        # m.2.0.S
        m.2.0.S[, rank:= as.numeric(0)]
        m.2.0.S[p.1 %in% tokens.2.0.sw,  rank:= rank-1]
        
        setkey(m.2.0.S, rank, freq)
        pred.2.0.S <- m.2.0.S[rank==min(rank), .(rank = rank -1 + 2, Ngram.model = -2, Ngram.submodel = "02.sw", freq = freq, prediction = p.0)]
        pred.2.0.S[,prob:= freq/sum(freq)] 
        pred.2.0.S <- pred.2.0.S[rank>=0,]
        ########################################################################

        output <- rbindlist(
                list(
                        pred.2.0= pred.2.0,
                        pred.3.0 = pred.3.0,
                        pred.4.0 = pred.4.0,
                        # pred.5.0 = pred.5.0,
                        # pred.6.0 = pred.6.0,
                        # pred.7.0 = pred.7.0,
                        
                        pred.2.03.S = pred.2.03.S,
                        pred.3.03.S = pred.3.03.S,
                        pred.4.03.S = pred.4.03.S,
                        
                        pred.2.0.S = pred.2.0.S,
                        pred.3.0.S = pred.3.0.S,
                        pred.4.0.S = pred.4.0.S
                )
        )
        
        setkey(output, rank, Ngram.model, Ngram.submodel, freq, prediction)
        output <- output[,.(freq = sum(freq)), by=.(rank, Ngram.model, Ngram.submodel, prediction)]
        
        setkey(output, rank, Ngram.model, Ngram.submodel, freq, prediction)
        output <- output[,.SD[1],by="prediction"]
        output <- output[rank==min(rank)]
        setkey(output, rank, Ngram.model, Ngram.submodel, freq, prediction)
        
        # 
        # last filter to avoid weird word repetiotion
        to.avoid <- tokens[1:4]
        output <- output[prediction %!in% to.avoid,]
        
        return(output)
        
}