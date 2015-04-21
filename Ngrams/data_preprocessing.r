## #######################################################
## Date: 04/17/2015
## Author: Kanti Chalasani
## Description: This R Script loads the source data including:
##   a- Load Source data 
##   b- Preprocess and Tidy up the data set(s)
##   c- Create Training/Test/Validation data.
##   d- Persist data for next steps
##########################################################

source("data_processing_routines.R")
	
	# Load Original dataset lines
	srcNews<-load_data("./data/Coursera-SwiftKey/final/en_US/en_US.news.txt")
	srcBlogs<-load_data("./data/Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
	srcTweets<-load_data("./data/Coursera-SwiftKey/final/en_US/en_US.twitter.txt")

	
	## Tidy up dataset
	#srcNews<-formSentences(srcNews)
	srcNews<-expand_contractions(srcNews)
	srcNews<-tidy_up_sentence(srcNews)
	
	#srcBlogs<-formSentences(srcBlogs)
	srcBlogs<-expand_contractions(srcBlogs)
	srcBlogs<-tidy_up_sentence(srcBlogs)
	
	#srcTweets<-formSentences(srcTweets)
	srcTweets<-expand_contractions(srcTweets)
	srcTweets<-tidy_up_sentence(srcTweets)
	
	srcData<-c(srcNews,srcBlogs,srcTweets)
	
	save(srcNews, srcBlogs, srcTweets, srcData, file="./data/cleanedSRCdata_V2.RData")

	
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
	
	save(srcTrainData, srcTestData, srcValidData, file="./data/mergedTrainingTestValid.RData")
	