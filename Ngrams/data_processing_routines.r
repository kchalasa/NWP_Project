## #######################################################
## Date: 04/17/2015
## Author: Kanti Chalasani
## Description: This packages contains all of the utility routines utilized in the Next Word Prediction Application
##########################################################

##############################################
## Load libraries 
##############################################
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(tm))
suppressPackageStartupMessages(library(slam))
suppressPackageStartupMessages(library(RWeka))
suppressPackageStartupMessages(library(wordcloud))
suppressPackageStartupMessages(library(R.utils))
suppressPackageStartupMessages(library(stringi))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(fastmatch))

##############################################
### File Processing Routines
##############################################
	## Functions for clean data file loading - by removing binary characters and converting latin1 to ASCII
			load_data<-function(filenm) {
					con<-file(filenm, open="rb")
					dat<-iconv(scan(file = con, what = character(0),  skipNul = TRUE, sep = "\n"), "latin1", "ASCII", sub="")
					close(con)
					return(dat)
					}

			load_words<-function(filenm) {
					con<-file(filenm, open="rb")
					##dat<-readLines(con, encoding="UTF-8")
					dat<-iconv(scan(file = con, what = character(),  skipNul = TRUE), "latin1", "ASCII", sub="")
					close(con)
					return(dat)
					}		

			get_file_size<-function(filenm) {
					file.info(filenm)$size / (1024*1024)
					}

##############################################
### Functions to TIDY up the data.
##############################################

	expand_contractions<-function(srcLine) {
			srcLine<-gsub("isn't",   "is not",         srcLine)
			srcLine<-gsub("aren't",   "are not",       srcLine)
			srcLine<-gsub("wasn't",   "was not",       srcLine)
			srcLine<-gsub("weren't",   "were not",     srcLine)
			srcLine<-gsub("haven't",   "have not",     srcLine)
			srcLine<-gsub("hasn't",   "has not",       srcLine)
			srcLine<-gsub("hadn't",   "had not",       srcLine)
			srcLine<-gsub("won't",   "will not",       srcLine)
			srcLine<-gsub("wouldn't",   "would not",   srcLine)
			srcLine<-gsub("don't",   "do not",         srcLine)
			srcLine<-gsub("doesn't",   "does not",     srcLine)
			srcLine<-gsub("didn't",   "did not",       srcLine)
			srcLine<-gsub("can't",   "cannot",         srcLine)
			srcLine<-gsub("couldn't",   "could not",   srcLine)
			srcLine<-gsub("shouldn't",   "should not", srcLine)
			srcLine<-gsub("mightn't",   "might not",   srcLine)
			srcLine<-gsub("mustn't",   "must not",     srcLine)
			srcLine<-gsub("would've",    "would have",   srcLine)	
			srcLine<-gsub("should've",   "should have",   srcLine)	
			srcLine<-gsub("could've",    "could have",   srcLine)	
			srcLine<-gsub("might've",    "might have",   srcLine)	
			srcLine<-gsub("must've",     "must have",   srcLine)
			srcLine<-	gsub("I'm","I am",	    srcLine)
			srcLine<-	gsub("I'll","I will",	srcLine)
			srcLine<-	gsub("I'd","I would",	srcLine)
			srcLine<-	gsub("I've","I have",	srcLine)
			srcLine<-	gsub("I'd","I had",	    srcLine)
			srcLine<-	gsub("we're","we are",	srcLine)
			srcLine<-	gsub("we'll","we will",	srcLine)
			srcLine<-	gsub("we'd","we would",	srcLine)
			srcLine<-	gsub("we've","we have",	srcLine)
			srcLine<-	gsub("we'd","we had",	srcLine)
			return(srcLine)
		}		

## set encoding to ANSI, and make them all lower case
	tidy_up_sentence<-function(srcLine) {
			srcLine<-tolower(srcLine)
			## Clean HTML String
			srcLine <- gsub("<.*?>", "", srcLine)
			srcLine<-gsub('â€™',"'",srcLine)
			srcLine<-gsub('â€œ','"',srcLine)
			srcLine<-gsub('â€¦',' ',srcLine)
			srcLine<-gsub("-"," ",srcLine)
			srcLine<-gsub("_","",srcLine)
			srcLine<-gsub("\a","",srcLine)
			srcLine<-gsub("\b","",srcLine)
			srcLine<-gsub("<","",srcLine)
			srcLine<-gsub(">","",srcLine)
			srcLine<-gsub("\\[","",srcLine)
			srcLine<-gsub("\\]","",srcLine)
			srcLine<-gsub("’","",srcLine)
			srcLine<-gsub('"',"",srcLine)
			## Single spacing between words 
			srcLine<-gsub("(\\s+)"," ",srcLine)
			## Remove spaces at the begining and end of the line. 
			srcLine<-gsub("^\\s+|\\s+$","",srcLine)
			srcLine<-gsub("[‘'´'`’’]","",srcLine)
			srcLine<-gsub('["””:]','',srcLine)
			srcLine<-gsub('[!({})%#&-,/]',' ',srcLine)
			srcLine<-gsub('[\\^\\*\\$\\?]','',srcLine)
			srcLine<-gsub('\\.',' ',srcLine)
			srcLine<-gsub('\\,',',',srcLine)
			srcLine<-gsub('â€','"',srcLine)
			srcLine<-gsub('[0-9]','',srcLine)
			srcLine<-gsub('[;@~=>|]','',srcLine)
			srcLine<-iconv(srcLine, "latin1", "ASCII", sub="")
			srcLine<-gsub("(\\s+)"," ",srcLine)
			srcLine <- gsub("!ðŸ‘¦","",srcLine)
			srcLine <-gsub("\xed ½\xed±¦","",srcLine)
			srcLine<-gsub("[%#&ÖÓÉÊÓÍ·ìí…ÌŽÆàÅè¡›áÏÚÛ‡†ºÎâæ¥Šæžä½¿ã£ã¦å°ã€Œ¨€½œ£¿¾Ÿï¼šï¼‰™ïœÃ©¢¶ƒ§Â¤“³»®Ä¹³»®««çª‹ˆ˜Ñ•ÐµÙØ±¬Ë„²ë¸êéî¯––×Ç\002\020\002#\023ð\035\037\177\032\031\003\001]","",srcLine)
			return(srcLine)
	}
		
	formSentences<-function(srcData) {
			srcData<-sent_detect(srcData)
			srcData<-srcData[sapply(gregexpr("\\S+", srcData), length)!=1]
			srcData
	}	


	splitWords<-function(doc, lnCount,filename) {
		for (i in 1:lnCount) {
			terms <- tolower(unlist(strsplit(doc[i], " ")))
			terms <- terms[nchar(terms) > 1 ]
		
			if (length(terms)>0)
				write(paste(terms,",1"), file=filename, append=TRUE)	
		}
	}

##############################################
## TM and RWEKA Packages used for exploratory data analysis
##############################################

	build_corpus<-function(src) {
			corpusB <- Corpus(VectorSource(src))
			corpusB <- tm_map(corpusB, stripWhitespace)
			corpusB <- tm_map(corpusB, content_transformer(tolower))
			##corpusB <- tm_map(corpusB, removeWords, stopwords("english"))
			corpusB <- tm_map(corpusB, removePunctuation)
			corpusB <- tm_map(corpusB, removeNumbers)
			corpusB <- tm_map(corpusB, stripWhitespace)
			return(corpusB)
	}

	corpusT<-function(crpus,dtm, n) {
					doc.length = rowSums(as.matrix(dtm))
					idx<-which(doc.length<=(n-1))
					if (length(idx)>0)
					crpus <- crpus[-idx]
					crpus
	}
				
	corpusTkns<-function(crpus, n) {
					if (n==1) 
					cTokenizer<- function(x) {
							RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 1, max = 1))
								}
					if (n==2) 
					cTokenizer<- function(x) {
							RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 2, max = 2))
								}
					if (n==3) 
					cTokenizer<- function(x) {
							RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 3, max = 3))
								}
								

					nwsTDM <- TermDocumentMatrix(
							crpus,
							control = list(tokenize = cTokenizer, weighting = weightTfIdf) #, minWordLength=2)
							
						)

	}

##############################################
### Sampling and Training Set generation functions
##############################################

	sampleSrc<-function(srcData,percent) {
			d_length<-length(srcData)
			idx<-sample(1:d_length,d_length*percent)
			d_Train <- srcData[idx]
			return(d_Train)
	}

	sampleData<-function(srcNews,srcTweets,srcBlogs,percent) {
			
			nwsSample<-sampleSrc(srcNews,percent)
			twtsSample<-sampleSrc(srcTweets,percent)
			blgsSample<-sampleSrc(srcBlogs,percent)
			
			srcSample<-c(nwsSample,twtsSample,blgsSample)
			
			return(srcSample)
		
	}

	createTraining<-function(srcData,percent) {
			d_length<-length(srcData)
			idx<-sample(1:d_length,d_length*percent)
			d_Train <- srcData[idx]
			
			test_pct<-(1-percent)/2

			# Load Training set
			idxTrain<-sample(1:d_length,d_length*percent)
			srcTrain <- srcData[idxTrain]
		
			# Of the Remaining set aside half for testing and half for cross validation

			src_remaining <- srcData[-idxTrain]
			idxRemain<-length(src_remaining)
			idxTest<-sample(1:idxRemain,idxRemain*0.50)
		
			# 15% Twitter Test Dataset
			srcTest <- src_remaining[idxTest]
		
			# 15% Twitter Cross Validation Dataset
			srcValid <- src_remaining[-idxTest]
			
			return(list(srcTrain,srcTest,srcValid))
			
	}

##############################################
### BASE R Utilities - Generate NGrams 
##############################################


## Initial method(s) was extremely slow ***NOT USED*** -- TRY NOT to GROW objects in R like below.

	gen_ngrams<-function(srcData,n,outfile) {
		src_words<-tolower(unlist(strsplit(srcData,"\\s")))
		len<-length(src_words)
		if (len>=n) {	
				for (i in 1:(len-(n-1)) )
				{
				txt_str=""
				for (k in 0:(n-1)) 
					if (txt_str=="") txt_str<-src_words[i+k]
					else txt_str<-paste(txt_str,src_words[i+k])
				write(txt_str, file=outfile, append=TRUE)
				}
				outfile }
		else {	write("", file=outfile, append=TRUE) 
				outfile }
		}
	
	ngram_freq<-function(infile) {
			con<-file(infile, open="rb")
			words<-readLines(con)
			close(con)
			ngram_tbl<-data.table(word=character(),count=numeric())
			ngram_tbl<-data.table(word=words,count=1)
			ngrams<-ngram_tbl[, .(count=sum(count)), by=word]
			setkey(ngrams, count, word)
			setorder(ngrams, -count, word)
			return(ngrams)
			ngram_tbl
		}
	
## Final method for generating TOKENS - Faster Version

	gen_ngrams2<-function(srcData,n) {
				options <- stringi::stri_opts_brkiter(type="word", skip_word_none = TRUE)
				src_words <- unlist(stringi::stri_split_boundaries(srcData, opts_brkiter=options))
				len<-length(src_words)
		
				ngrams<-character(0)
		
				if (len>=n) {
					ngrams<-sapply(1:max(1, (len-(n-1))),
							function(i) stringi::stri_join(src_words[i:min(len, i + n - 1)], collapse = " ")
						)
					}
				ngrams
	}



	ngram_freq2<-function(srcWords) {
			ngram_frq<-data.table(word=srcWords,count=1)
			ngram_frq<-ngram_frq[, .(count=sum(count)), by=word]
			return(ngram_frq)
		}

##############################################
### Evaluation Routines - Used to measure ACCURACY of NWP Model 
##############################################

## Input Parameters: TEST_PHRASE(s), NEXT_WORD(s)
## Returns: A data.table with TEST_PHRASE, ACTUAL_NEXT_WORD, PREDICTED_NEXT_WORD

	evaluate_pred<-function(test_phrase,test_result)
	{
		DT<-data.table()	
			## Invoke Next_Word_Prediction for EACH input Phrase
			for (i in 1:length(test_phrase)) {
				DT<-rbind(DT,data.table(test_phrase=test_phrase[i],test_word=test_result[i],pred=t(lapply(test_phrase[i],FUN=predict_next_word))))
				}
		DT
	}

### INPUT: A data.table with TEST_PHRASE, ACTUAL_NEXT_WORD, PREDICTED_NEXT_WORD
### OUTPUT: ACCURACY MEASURE of this batch of Test Phrases

	evaluate_accuracy<-function(DT) {
		result<-TRUE
		
		for (i in 1:nrow(DT))
			result[i]<-DT[i,]$test_word %in% unlist(DT[i,]$pred)
			
		## Compute Accuracy of this set
		sum(ifelse(result,1,0))/length(result)*100
	}	


	batch_evaluation2<-function(Test_Phrases,Test_Results) {
			## Define Partition(s) for TEST PHRASES - 1000 phrases in each part
			parts<-round(seq(1,length(Test_Phrases), by=1000))
			
			## Initialize RESULT data.table
			evaluation_result<-data.table(part_id=character(2000),accuracy=numeric(2000))
			
			## Limit evaluation to 2000 partitions -- might increase this limit as needed.
			
				for (i in 1:2000) {  ##for (i in 1:(length(parts)-1)) {
					
					## Take 250 phrases from each partitions
					idx<-round(seq(parts[i],parts[i+1], by=4))
					test_phrase<-Test_Phrases[idx]
					test_result<-Test_Results[idx]
					
					## RUN PREDICTION for TEST phrases; Compute ACCURACY 
					e_pred<-evaluate_pred(test_phrase,test_result)
					e_acc<-evaluate_accuracy(e_pred)
					
					## Record ACCURACY for this RUN
					evaluation_result[i]$part_id<-paste(parts[i],":",parts[i+1])
					evaluation_result[i]$accuracy<-e_acc
				}
				
			evaluation_result
	}
