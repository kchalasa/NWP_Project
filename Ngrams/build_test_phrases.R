## TEST PHRASE(s) and ACTUAL NEXT WORD(s) for MERGED TEST SET

load("./data/mergedTrainingTestValid.RData")

quad_test_grams<-gen_ngrams2(srcTestData,4)

qgram_phrase<-do.call(rbind, strsplit(quad_test_grams, ' (?=[^ ]+$)', perl=TRUE))[,1]
qgram_result<-do.call(rbind, strsplit(quad_test_grams, ' (?=[^ ]+$)', perl=TRUE))[,2]
qgram_result<-data.table(test_word=qgram_result)

save(quad_test_grams,qgram_phrase,qgram_result,file="./data/testphrases.RData")

## Test Phrases By INPUT data type

load("./data/splitTrainTestValid.RData")

## NEWS Phrases
news_test_grams<-gen_ngrams2(srcTestNews,4)
nws_testphrase<-do.call(rbind, strsplit(news_test_grams, ' (?=[^ ]+$)', perl=TRUE))[,1]
nws_test_result<-do.call(rbind, strsplit(news_test_grams, ' (?=[^ ]+$)', perl=TRUE))[,2]
save(news_test_grams,nws_testphrase,nws_test_result,file="./data/newstestphrases.RData")

## TWITTER Phrases
twitter_test_grams<-gen_ngrams2(srcTestTweets,4)
twts_testphrase<-do.call(rbind, strsplit(twitter_test_grams, ' (?=[^ ]+$)', perl=TRUE))[,1]
twts_test_result<-do.call(rbind, strsplit(twitter_test_grams, ' (?=[^ ]+$)', perl=TRUE))[,2]
save(twitter_test_grams,twts_testphrase,twts_test_result,file="./data/twittertestphrases.RData")

## BLOGS Phrases
blogs_test_grams<-gen_ngrams2(srcTestBlogs,4)
blgs_testphrase<-do.call(rbind, strsplit(blogs_test_grams, ' (?=[^ ]+$)', perl=TRUE))[,1]
blgs_test_result<-do.call(rbind, strsplit(blogs_test_grams, ' (?=[^ ]+$)', perl=TRUE))[,2]
save(blogs_test_grams,blgs_testphrase,blgs_test_result,file="./data/blogstestphrases.RData")
