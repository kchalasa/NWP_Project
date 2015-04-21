setwd("C:/Kanti/NLP2")
library(data.table)

### LOAD FULL NGRAMS for Kneser Ney Smoothing

load("./data/new_ngrams_FULL.RData")

##Unigrams
unigrams$pKN<-unigrams$count/(sum(unigrams$count)-1)

## Bigrams

##0.68
D_uni<- nrow(unigrams[unigrams$count==1,])/(nrow(unigrams[unigrams$count==1,])+2*nrow(unigrams[unigrams$count==2,]))

setkey(bigrams,word1)
lambda<-bigrams[,.(lambda=(D_uni/sum(count)),w1_cnt=sum(count)),by=word1]
setkey(lambda,word1)
bigrams<-merge(bigrams,lambda)

setkey(bigrams,word2)
p_continuation<-bigrams[,.(pCN=.N/(nrow(bigrams)-1)),by=word2]
setkey(p_continuation,word2)
bigrams<-merge(bigrams,p_continuation)

p_KN<-bigrams[,.(pKN=((max((count-D_uni),0))/w1_cnt) +(lambda*w1_cnt*pCN)),by=.(word1,word2)]
setkey(bigrams,word1,word2)
setkey(p_KN,word1,word2)
bigrams<-merge(bigrams,p_KN)
bigrams<-bigrams[,.(word1,word2,count,pKN)]



## Trigrams
##0.75
D_bi<- nrow(bigrams[bigrams$count==1,])/(nrow(bigrams[bigrams$count==1,])+(2*nrow(bigrams[bigrams$count==2,])))

lambda<-trigrams[,.(lambda=(D_bi/sum(count)),w1w2_cnt=sum(count)),by=.(word1,word2)]
p_continuation<-trigrams[,.(pCN=.N/(nrow(trigrams)-1)),by=.(word2,word3)]
setkey(trigrams,word1,word2)
trigrams<-merge(trigrams,lambda)
setkey(trigrams,word2,word3)
trigrams<-merge(trigrams,p_continuation)

p_KN<-trigrams[,.(pKN=((max((count-D_bi),0))/w1w2_cnt) +(lambda*w1w2_cnt*pCN)),by=.(word1,word2,word3)]

setkey(trigrams,word1,word2,word3)
setkey(p_KN,word1,word2,word3)
trigrams<-merge(trigrams,p_KN)
trigrams<-trigrams[,.(word1,word2,word3,count,pKN)]


###quadgrams

D_tri<- nrow(trigrams[trigrams$count==1,])/(nrow(trigrams[trigrams$count==1,]) +(2*nrow(trigrams[trigrams$count==2,])))


setkey(quadgrams,word1,word2,word3)
lambda<-quadgrams[,.(lambda=(D_tri/sum(count)),w1w2w3_cnt=sum(count)),by=.(word1,word2,word3)]
setkey(lambda,word1,word2,word3)
quadgrams<-merge(quadgrams,lambda)


setkey(quadgrams,word2,word3,word4)
p_continuation<-quadgrams[,.(pCN=.N/(nrow(quadgrams)-1)),by=.(word2,word3,word4)]
setkey(p_continuation,word2,word3,word4)
quadgrams<-merge(quadgrams,p_continuation)

setkey(quadgrams,word1,word2,word3,word4)
p_KN<-quadgrams[,.(pKN=((max((count-D_tri),0))/w1w2w3_cnt) +(lambda*w1w2w3_cnt*pCN)),by=.(word1,word2,word3,word4)]
setkey(p_KN,word1,word2,word3,word4)
quadgrams<-merge(quadgrams,p_KN)

quadgrams<-quadgrams[,.(word1,word2,word3,word4,count,pKN)]


setorder(bigrams,-pKN,word1,word2)
setkey(bigrams,word1)

setorder(trigrams,-pKN,word1,word2,word3)
setkey(trigrams,word1,word2)

## Load Bad Words That need MASKING 
filter_words<-c("",readLines("./data/badwords_final.txt"))

save(unigrams,bigrams,trigrams,quadgrams,filter_words,file="./data/new_ngrams_KN_FULL.RData")

