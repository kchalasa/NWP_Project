## #######################################################
## Date: 04/17/2015
## Author: Kanti Chalasani
## Description: This R Script generates conditional Probability for the language model
## For unigrams conditional probability is maximum likelihood Estimate
## For higher n grams, frequency of the words preceding the word and its usage history in the document is used to set the probability
##########################################################

library(data.table)

########### LOAD NGRAMS######################
load("./data/unigrams_out_train.RData")
load("./data/bigrams_out_train.RData")
load("./data/trigrams_out_train.RData")
load("./data/quadgrams_out_train.RData")

# COMPUTE CONDITIONAL PROBABIBILITY - Maximum Likelihood estimates (MLE) ===============

## Unigrams MLE

unigrams$MLE<-unigrams$count/sum(unigrams$count)

## Bigrams MLE

bigrams<-bigrams[,.(word1,word2,count)]
setkey(bigrams,word1)
bg_cumsum<-bigrams[,.(bgcount=sum(count)),by=word1]
setkey(bg_cumsum,word1)
bigrams<-merge(bigrams,bg_cumsum)
bigrams<-bigrams[,.(word1,word2,count,MLE=count/bgcount)]

## Trigrams MLE


tri_cumsum<-trigrams[,.(tricount=sum(count)),by=.(word1,word2)]
setkey(tri_cumsum,word1,word2)
setkey(trigrams,word1,word2)
trigrams<-merge(trigrams,tri_cumsum)
trigrams<-trigrams[,.(word1,word2,word3,count,MLE=count/tricount)]

## Quadgrams MLE

quad_cumsum<-quadgrams[,.(quadcount=sum(count)),by=.(word1,word2,word3)]
setkey(quad_cumsum,word1,word2,word3)
setkey(quadgrams,word1,word2,word3)
quadgrams<-merge(quadgrams,quad_cumsum)
quadgrams<-quadgrams[,.(word1,word2,word3,word4,count,MLE=count/quadcount)]

## Sort by MLE

setorder(unigrams,-MLE,word1)
setkey(unigrams,word1)

setorder(bigrams,-MLE,word1,word2)
setkey(bigrams,word1)

setorder(trigrams,-MLE,word1,word2,word3)
setkey(trigrams,word1,word2)

setorder(quadgrams,-MLE,word1,word2,word3,word4)
setkey(quadgrams,word1,word2,word3)

save(unigrams,bigrams,trigrams,quadgrams,filter_words,file="./data/ngrams_FULL_MLE.RData")
