suppressPackageStartupMessages(library(data.table))
source("helpers.R")
load("ngrams.RData")


predict_next_word<-function(input_str) {
	suppressPackageStartupMessages(library(data.table))
		##/* Apply same cleanup as on the Training Samplene*/

		input_str<-expand_contractions(input_str)
		input_str<-tidy_up_sentence(input_str)
		input_str<-tolower(input_str)

		##/* Split to input_wrds */

		input_wrds<- unlist(strsplit(input_str, "\\s+"), use.names=FALSE)
		
			len <- length(input_wrds)
			
			predicted_words <- data.table(prob=numeric(),word=character(),ngram=character())
			
			## QUADGRAM Prediction: If number of input words greater than or equal to 3.
			if (len >= 3) {
				wrds_matched <- quadgrams[J(input_wrds[len-2], input_wrds[len-1], input_wrds[len]),.(prob=MLE*0.04,word=word4,ngram="fourgram")]
				predicted_words <-wrds_matched[!is.na(wrds_matched$word)]
				##print(paste("quad",nrow(predicted_words)))
			}
			## TRIGRAM Prediction: If number of input words greater than or equal to 2 or BACKOFF from QUADGRAM. 
			if (len >= 2 & nrow(predicted_words) < 4) {
				wrds_matched <- trigrams[J(input_wrds[len-1], input_wrds[len]),.(prob=MLE*0.02,word=word3,ngram="trigram")]
				predicted_words <- rbind(predicted_words, wrds_matched)
				predicted_words <-predicted_words[!is.na(predicted_words$word)]
				##print(paste("tri",nrow(predicted_words)))
			}
			## BIGRAM Prediction: If number of input words greater than or equal to 1 or BACKOFF from TRIGRAM. 
			if (len >= 1 & nrow(predicted_words) < 4) {
				wrds_matched <- bigrams[J(input_wrds[len]),.(prob=MLE*0.001,word=word2,ngram="bigram")]
				predicted_words <- rbind(predicted_words, wrds_matched)
				predicted_words <-predicted_words[!is.na(predicted_words$word)]
				##print(paste("bi",nrow(predicted_words)))
			}
			
			## UNIGRAM Prediction: BACKOFF from BIGRAM. 
			if (nrow(predicted_words) < 4) {
				## Get top three words using MAXIMUM LIKELIHOOD ESTIMATE for PROBABILITY
				if (len!=0) {
					wrds_matched <-head(unigrams[grep(input_wrds[len], unigrams$word),]$word,3)
					wrds_matched<-setdiff(wrds_matched,input_wrds[len])
					if (length(wrds_matched)!=0) {
						wrds_matched<-unigrams[ unigrams$word1 %in% wrds_matched,.(prob=MLE,word=word1,ngram="unigram")]
					} 
					if (length(wrds_matched)!=0)
					predicted_words <- rbind(predicted_words, wrds_matched)
				}
				if (nrow(predicted_words)==0) {
				    predicted_words<-unigrams[ unigrams$word1 %in% c("the","and"),.(prob=MLE,word=word1,ngram="unigram")]
				}
				## print(paste("uni",nrow(predicted_words)))
				predicted_words$prob<-predicted_words$prob*0.005
			}
			contains_bad_words<-length(unique(predicted_words$word %in% filter_words))
			type_of_bad_wrd<-unique(predicted_words$word %in% filter_words)

			predicted_words<-predicted_words[!is.na(predicted_words$word),]
			#predicted_words<-predicted_words[,.(prob=sum(prob)),by=word]
			
	
			if(length(type_of_bad_wrd)!=0 & sort(type_of_bad_wrd,decreasing=TRUE)[1])
			{ predicted_words[(predicted_words$word %in% filter_words),]$word<-"****" 
			}
	
			## FOR Shiny Application we return entire predicted_words data.table
			## For one WORD evaluation we ONLY return first word.
			predicted_words<-head(predicted_words$word,1) 
	    
return(predicted_words)

}

