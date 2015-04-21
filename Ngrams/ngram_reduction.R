################### NGRAMS PRUNING (REDUCTION) ####################

load("./data/ngrams_FULL_MLE.RData")
## Unigram Reduction
unigrams<-unigrams[unigrams$count>30,]
setorder(unigrams,-count,word1)
setkey(unigrams,word1)
save(unigrams,file="./data/ngrams_uni_MLE.RData")

## Bigram Reduction
bigrams<-bigrams[bigrams$count>8,]

setorder(bigrams,-count,word1,word2)
setkey(bigrams,word1)
save(bigrams,file="./data/ngrams_bi_MLE.RData")

## Trigram Reduction
trigrams<-trigrams[trigrams$count>8,]
setorder(trigrams,-count,word1,word2,word3)
setkey(trigrams,word1,word2)

save(trigrams,file="./data/ngrams_tri_MLE.RData")

## Quadgram Reduction
quadgrams<-quadgrams[quadgrams$count>10,]
setorder(quadgrams,-count,word1,word2,word3,word4)
setkey(quadgrams,word1,word2,word3)
save(quadgrams,file="./data/ngrams_quad_MLE.RData")

## Load Bad Words That need MASKING 
filter_words<-c("",readLines("./data/badwords_final.txt"))

save(unigrams,bigrams,trigrams,quadgrams,filter_words,file="./data/new_ngrams_MLE.RData")
