#####################################################
##  This R Script has selected Exploratory Analysis code
##  Build and Clean Corpus using TM and RWEKA packages
######################################################
source("data_processing_routines.R")
library(reshape2)


## Load pre-processed  training data set 
	load("./data/splitTrainTestValid.RData")

## Take 1% from each type of the training data set for exploratory data analysis
			smplData<-sampleData(srcTrainTweets, srcTrainBlogs, srcTrainNews,0.1)
			
## Build Corpus MERGED SET using TM package 

		smplCorpus<-build_corpus(smplData)
		sprseDTM<- DocumentTermMatrix(smplCorpus, control=list(minDocFreq=2))
		smplDTM<-removeSparseTerms(sprseDTM, sparse=0.9995)

## Build Unigrams, bigrams, trigrams using RWEKA
		smpl_unigramTDM<-corpusTkns(corpusT(smplCorpus,smplDTM, 1),1)
		smpl_bigramTDM<-corpusTkns(corpusT(smplCorpus,smplDTM, 2),2)
		smpl_trigramTDM<-corpusTkns(corpusT(smplCorpus,smplDTM, 3),3)

save(smplData,smplCorpus,sprseDTM,smplDTM, file="data/corpusSample.RData")

## For exploratory analysis include only top 25K frequent words

smp_unigrams<-melt(as.matrix(head(sort(row_sums(smpl_unigramTDM), decreasing = TRUE),25000)))
smp_bigramTDM<-melt(as.matrix(head(sort(row_sums(smpl_bigramTDM), decreasing = TRUE),25000)))
smp_trigramTDM<-melt(as.matrix(head(sort(row_sums(smpl_trigramTDM), decreasing = TRUE),25000)))
  
smp_unigrams<-smp_unigrams[,c(1,3)]
names(smp_unigrams)<-c("word","freq")
smp_bigramTDM<-smp_bigramTDM[,c(1,3)]
names(smp_bigramTDM)<-c("word","freq")
smp_trigramTDM<-smp_trigramTDM[,c(1,3)]
names(smp_trigramTDM)<-c("word","freq")
  
save(smpl_unigramTDM,smp_unigrams, file="data/smpl_unigramTDM.RData")
save(smpl_bigramTDM,smp_bigramTDM, file="data/smpl_bigramTDM.RData")
save(smpl_trigramTDM,smp_trigramTDM, file="data/smpl_trigramTDM.RData")
  
## Reduce unigrams,bigrams and trigrams further for milestone report

uni_smpl<-subset(smp_unigrams, freq>5000)
bi_smpl<-subset(smp_bigramTDM, freq>1500)
tri_smpl<-subset(smp_trigramTDM, freq>400)

save(uni_smpl,bi_smpl,tri_smpl,file="./data/exploratorysrcData.RData")

##============Hierarchical Clustering===============


sTDM<-removeSparseTerms(smpl_unigramTDM, sparse=0.95)
distMatrix<-dist(scale(sTDM))
sample.fit<-hclust(distMatrix,method="ward")

save(sTDM,distMatrix,sample.fit"./data/exploratoryHCLUST.Rdata")

######################################################################
## Individual data set type analysis
######################################################################

## Get 1% of each type of sample data type
			smplNews<-sampleSrc(srcTrainNews,0.1)
			smplBlogs<-sampleSrc(srcTrainBlogs,0.1)
			smplTweets<-sampleSrc(srcTrainTweets,0.1)
			
######################################
### NEWS
######################################
## Build Corpus News SET using TM package 

		newsCorpus<-build_corpus(smplNews)
		newsDTM<- DocumentTermMatrix(newsCorpus, control=list(minDocFreq=2))
		nwsDTM<-removeSparseTerms(newsDTM, sparse=0.9995)

## Build Unigrams, bigrams, trigrams using RWEKA
		nws_unigrams<-corpusTkns(corpusT(newsCorpus,nwsDTM, 1),1)
		nws_bigrams<-corpusTkns(corpusT(newsCorpus,nwsDTM, 2),2)
		nws_trigrams<-corpusTkns(corpusT(newsCorpus,nwsDTM, 3),3)

######################################
### Tweets
######################################
## Build Corpus Tweets SET using TM package 

		TweetsCorpus<-build_corpus(smplTweets)
		TweetsDTM<- DocumentTermMatrix(TweetsCorpus, control=list(minDocFreq=2))
		twtsDTM<-removeSparseTerms(TweetsDTM, sparse=0.9995)

## Build Unigrams, bigrams, trigrams using RWEKA
		twts_unigrams<-corpusTkns(corpusT(TweetsCorpus,twtsDTM, 1),1)
		twts_bigrams<-corpusTkns(corpusT(TweetsCorpus,twtsDTM, 2),2)
		twts_trigrams<-corpusTkns(corpusT(TweetsCorpus,twtsDTM, 3),3)
		
######################################
### Blogs
######################################
## Build Corpus Blogs SET using TM package 

		BlogsCorpus<-build_corpus(smplBlogs)
		BlogsDTM<- DocumentTermMatrix(BlogsCorpus, control=list(minDocFreq=2))
		blgsDTM<-removeSparseTerms(BlogsDTM, sparse=0.9995)

## Build Unigrams, bigrams, trigrams using RWEKA
		blgs_unigrams<-corpusTkns(corpusT(BlogsCorpus,blgsDTM, 1),1)
		blgs_bigrams<-corpusTkns(corpusT(BlogsCorpus,blgsDTM, 2),2)
		blgs_trigrams<-corpusTkns(corpusT(BlogsCorpus,blgsDTM, 3),3)	

##########################################################
###  Coverage Plots and More exploratory analysis Data
##########################################################

## Merged Set
src_ugrams<-melt(as.matrix(head(sort(row_sums(smpl_unigramTDM), decreasing = TRUE),50000)))
src_ugrams<-src_ugrams[,c(1,3)]
names(src_ugrams)<-c("word","freq")

## News
n_unigrams<-melt(as.matrix(head(sort(row_sums(nws_unigrams), decreasing = TRUE),50000)))
n_unigrams<-n_unigrams[,c(1,3)]
names(n_unigrams)<-c("word","freq")

n_trigrams<-melt(as.matrix(head(sort(row_sums(nws_trigrams), decreasing = TRUE),50000)))
n_trigrams<-n_trigrams[,c(1,3)]
names(n_trigrams)<-c("word","freq")

## Tweets
t_unigrams<-melt(as.matrix(head(sort(row_sums(twts_unigrams), decreasing = TRUE),50000)))
t_unigrams<-t_unigrams[,c(1,3)]
names(t_unigrams)<-c("word","freq")

t_trigrams<-melt(as.matrix(head(sort(row_sums(twts_trigrams), decreasing = TRUE),50000)))
t_trigrams<-t_trigrams[,c(1,3)]
names(t_trigrams)<-c("word","freq")

## Blogs
b_unigrams<-melt(as.matrix(head(sort(row_sums(blgs_unigrams), decreasing = TRUE),50000)))
b_unigrams<-b_unigrams[,c(1,3)]
names(b_unigrams)<-c("word","freq")

b_trigrams<-melt(as.matrix(head(sort(row_sums(blgs_trigrams), decreasing = TRUE),50000)))
b_trigrams<-b_trigrams[,c(1,3)]
names(b_trigrams)<-c("word","freq")

save(src_ugrams,n_unigrams,t_unigrams,b_unigrams,file="./data/exploratoryCoveragePlot.Rdata")	

save(n_trigrams,t_trigrams,b_trigrams,file="./data/exploratoryChartsData.RData")	
