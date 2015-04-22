## #######################################################
## Date: 04/17/2015
## Author: Kanti Chalasani
## Description: This R Script loads the source data including:
##   a- Load Source data 
##   b- Generate counts for exploratory Analysis
##   c- Preprocess and Tidy up the data set(s)
##   d- Create Training/Test/Validation data.
##   e- Persist data for next steps
##########################################################
	# Load Original dataset lines
	srcNews<-load_data("./data/Coursera-SwiftKey/final/en_US/en_US.news.txt")
	srcBlogs<-load_data("./data/Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
	srcTweets<-load_data("./data/Coursera-SwiftKey/final/en_US/en_US.twitter.txt")
	
	save(srcNews, srcBlogs, srcTweets, file="./data/originalSRCdata.RData")

	# File Line Counts
	nws_length <- length(srcNews)
	twts_length <- length(srcTweets)
	blgs_length <- length(srcBlogs)
	
	
	# Load News words
	news_words<-load_words("./data/Coursera-SwiftKey/final/en_US/en_US.news.txt")
	twts_words <- load_words("./data/Coursera-SwiftKey/final/en_US/en_US.twitter.txt")
	blgs_words <- load_words("./data/Coursera-SwiftKey/final/en_US/en_US.blogs.txt")

	# News File Size in MegaBytes (MB)
	nws_fsize<-get_file_size("./data/Coursera-SwiftKey/final/en_US/en_US.news.txt")
	twts_fsize<-get_file_size("./data/Coursera-SwiftKey/final/en_US/en_US.twitter.txt")
	blgs_fsize<-get_file_size("./data/Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
	
	# Word Count in News
	nws_word_count<-length(news_words)
	twts_word_count<-length(twts_words)
	blgs_word_count<-length(blgs_words)

    save(nws_fsize,nws_length,nws_word_count,twts_fsize,twts_length ,twts_word_count,blgs_fsize,blgs_length  ,blgs_word_count, file="./data/orig_datacounts.RData")
	
	## Tidy up dataset
	srcNews<-expand_contractions(srcNews)
	srcNews<-tidy_up_sentence(srcNews)
	
	srcBlogs<-expand_contractions(srcBlogs)
	srcBlogs<-tidy_up_sentence(srcBlogs)
	
	srcTweets<-expand_contractions(srcTweets)
	srcTweets<-tidy_up_sentence(srcTweets)
	
	srcData<-c(srcNews,srcBlogs,srcTweets)
	
	save(srcNews, srcBlogs, srcTweets, srcData, file="./data/cleanedSRCdata.RData")


	# Create data set for initial exploration with 10% from each data set
	smplData<-sampleData(srcNews,srcTweets,srcBlogs,0.1)
	smplData<-tidy_up_sentence(smplData)
	
	
	# Create Training, Test and Validation set for NEWS
	splitDataSet<-createTraining(srcNews,0.7)
	srcTrainNews<-unlist(splitDataSet[1])
	srcTestNews<-unlist(splitDataSet[2])
	srcValidNews<-unlist(splitDataSet[3])
	
	# Create Training, Test and Validation set for Blogs
		splitDataSet<-createTraining(srcBlogs,0.7)
		srcTrainBlogs<-unlist(splitDataSet[1])
		srcTestBlogs<-unlist(splitDataSet[2])
		srcValidBlogs<-unlist(splitDataSet[3])	
		
	# Create Training, Test and Validation set for Tweets
		splitDataSet<-createTraining(srcTweets,0.7)
		srcTrainTweets<-unlist(splitDataSet[1])
		srcTestTweets<-unlist(splitDataSet[2])
		srcValidTweets<-unlist(splitDataSet[3])		
		
	## FINAL Training - containing all data flavors.
		srcTrainData<-c(srcTrainNews,srcTrainBlogs,srcTrainTweets)	
		srcTestData<-c(srcTestNews,srcTestBlogs,srcTestTweets)	
		srcValidData<-c(srcValidNews,srcValidBlogs,srcValidTweets)	


	save(srcTrainTweets, srcTrainBlogs, srcTrainNews,srcTestNews,srcTestBlogs,srcTestTweets,srcValidBlogs,srcValidNews,srcValidTweets, file="./data/splitTrainTestValid.RData")
	
	save(srcTestNews,srcTestBlogs,srcTestTweets, file="./data/srcCompleteTESTData.RData")

	save(srcTrainData, srcTestData, srcValidData, file="./data/mergedTrainingTestValid.RData")