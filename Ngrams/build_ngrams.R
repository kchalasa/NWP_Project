## #######################################################
## Date: 04/17/2015
## Author: Kanti Chalasani
## Description: This R Script generates NGRAMS for the language model
##########################################################

source("data_processing_routines.R")
load("./data/mergedTrainingTestValid.RData")

########### BUILD NGRAMS######################

# Create full training set unigrams
unigrams_tokens<-gen_ngrams2(srcTrainData,1)
unigrams<-ngram_freq2(unigrams_tokens)

names(unigrams)<-c("word1","count")
unigrams<-unigrams[!(substring(unigrams$word1,1,3) %in% c("aba","aca","aaa","bbb","ccc","ddd","eee","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
unigrams<-unigrams[!(substring(unigrams$word1,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
unigrams<-unigrams[!(unigrams$word1 %in% c("m","p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]

save(unigrams_tokens,unigrams,file="./data/unigrams_out_train.RData")

# Create full training set bigrams
bigrams_tokens<-gen_ngrams2(srcTrainData,2)
bigrams<-ngram_freq2(bigrams_tokens)
bigrams$word1<-substring(bigrams$word, 1, regexpr(" ", bigrams$word)-1)
bigrams$word2<-substring(substring(bigrams$word, regexpr(" ", bigrams$word)+1),  regexpr(" ", substring(bigrams$word, regexpr(" ", bigrams$word)+1))-1)
bigrams<-bigrams[!(substring(bigrams$word1,1,3) %in% c("aba","aca","aaa","bbb","ccc","ddd","eee","fff","ggg","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
bigrams<-bigrams[!(substring(bigrams$word2,1,3) %in% c("aba","aca","aaa","bbb","ccc","ddd","eee","fff","ggg","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
bigrams<-bigrams[!(substring(bigrams$word1,1,2) %in% c("aba","aca","aa","bb","cc","dd","ee","ff","gg","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
bigrams<-bigrams[!(bigrams$word1 %in% c("m", "s", "u" ,"p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]
bigrams<-bigrams[!(substring(bigrams$word2,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
bigrams<-bigrams[!(bigrams$word2 %in% c("m", "s", "u" ,"p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]



save(bigrams_tokens,bigrams,file="./data/bigrams_out_train.RData")

# Create full training set trigrams
trigrams_tokens<-gen_ngrams2(srcTrainData,3)
trigrams<-ngram_freq2(trigrams_tokens)

trigrams<-trigrams[,c(3,4,5,2)]
trigrams$word1<-substring(trigrams$word, 1, regexpr(" ", trigrams$word)-1)
trigrams$word2<-substring(substring(trigrams$word, regexpr(" ", trigrams$word)+1), 1, regexpr(" ", substring(trigrams$word, regexpr(" ", trigrams$word)+1))-1)
trigrams$word3<-substring(substring(substring(trigrams$word, regexpr(" ", trigrams$word)+1),  regexpr(" ", substring(trigrams$word, regexpr(" ", trigrams$word)+1))+1),  regexpr(" ", substring(substring(trigrams$word, regexpr(" ", trigrams$word)+1),  regexpr(" ", substring(trigrams$word, regexpr(" ", trigrams$word)+1))+1))-1)
trigrams<-trigrams[!(substring(trigrams$word1,1,3) %in% c("aba","aca","aaa","bbb","ccc","ddd","eee","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
trigrams<-trigrams[!(substring(trigrams$word2,1,3) %in% c("aba","aca","aaa","bbb","ccc","ddd","eee","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
trigrams<-trigrams[!(substring(trigrams$word3,1,3) %in% c("aba","aca","aaa","bbb","ccc","ddd","eee","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
trigrams<-trigrams[!(substring(trigrams$word1,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
trigrams<-trigrams[!(substring(trigrams$word2,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
trigrams<-trigrams[!(substring(trigrams$word3,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
trigrams<-trigrams[!(trigrams$word1 %in% c("m" ,"p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]
trigrams<-trigrams[!(trigrams$word2 %in% c("m" ,"p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]
trigrams<-trigrams[!(trigrams$word3 %in% c("m" ,"p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]


save(trigrams_tokens,trigrams,file="./data/trigrams_out_train.RData")

# Create full training set trigrams
quadgrams_tokens<-gen_ngrams2(srcTrainData,4)
quadgrams<-ngram_freq2(quadgrams_tokens)

quadgrams$word1<-substring(quadgrams$word, 1, regexpr(" ", quadgrams$word)-1)
quadgrams$word2<-substring(substring(quadgrams$word, regexpr(" ", quadgrams$word)+1), 1, regexpr(" ", substring(quadgrams$word, regexpr(" ", quadgrams$word)+1))-1)
quadgrams$word3<-substring(substring(substring(quadgrams$word, regexpr(" ", quadgrams$word)+1),  regexpr(" ", substring(quadgrams$word, regexpr(" ", quadgrams$word)+1))+1), 1, regexpr(" ", substring(substring(quadgrams$word, regexpr(" ", quadgrams$word)+1),  regexpr(" ", substring(quadgrams$word, regexpr(" ", quadgrams$word)+1))+1))-1)
quadgrams$word4<-substring(substring(substring(substring(quadgrams$word, regexpr(" ", quadgrams$word)+1),  regexpr(" ", substring(quadgrams$word, regexpr(" ", quadgrams$word)+1))+1), regexpr(" ", substring(substring(quadgrams$word, regexpr(" ", quadgrams$word)+1),  regexpr(" ", substring(quadgrams$word, regexpr(" ", quadgrams$word)+1))+1))+1),
					regexpr(" ", substring(substring(substring(quadgrams$word, regexpr(" ", quadgrams$word)+1),  regexpr(" ", substring(quadgrams$word, regexpr(" ", quadgrams$word)+1))+1), regexpr(" ", substring(substring(quadgrams$word, regexpr(" ", quadgrams$word)+1),  regexpr(" ", substring(quadgrams$word, regexpr(" ", quadgrams$word)+1))+1))+1))-1)

quadgrams<-quadgrams[,c(3,4,5,6,2)]
					
quadgrams<-quadgrams[!(substring(quadgrams$word1,1,3) %in% c("aaa","bbb","ccc","ddd","eee","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
quadgrams<-quadgrams[!(substring(quadgrams$word2,1,3) %in% c("aaa","bbb","ccc","ddd","eee","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
quadgrams<-quadgrams[!(substring(quadgrams$word3,1,3) %in% c("aaa","bbb","ccc","ddd","eee","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]
quadgrams<-quadgrams[!(substring(quadgrams$word4,1,3) %in% c("aaa","bbb","ccc","ddd","eee","hhh","iii","jjj","kkk","lll","mmm","nnn","ooo","ppp","qqq","rrr","sss","ttt","uuu","vvv","www","xxx","yyy","zzz")),]

quadgrams<-quadgrams[!(substring(quadgrams$word1,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
quadgrams<-quadgrams[!(substring(quadgrams$word2,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
quadgrams<-quadgrams[!(substring(quadgrams$word3,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]
quadgrams<-quadgrams[!(substring(quadgrams$word4,1,2) %in% c("aa","bb","cc","dd","ee","hh","ii","jj","kk","ll","mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz")),]


quadgrams<-quadgrams[!(quadgrams$word1 %in% c("m","p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]
quadgrams<-quadgrams[!(quadgrams$word2 %in% c("m","p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]
quadgrams<-quadgrams[!(quadgrams$word3 %in% c("m","p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]
quadgrams<-quadgrams[!(quadgrams$word4 %in% c("m","p" ,"r" ,"g" ,"d" ,"o", "b", "e", "q" ,"c" ,"l", "j", "w", "t" ,"y", "x", "n", "h", "f", "k", "v", "z")),]


save(quadgrams_tokens,quadgrams,file="./data/quadgrams_out_train.RData")

filter_words<-c("",readLines("./data/badwords_final.txt"))

save(unigrams,bigrams,trigrams,quadgrams,filter_words,file="./data/new_ngrams_FULL.RData")

