load("./data/testphrases.RData")
load("./data/newstestphrases.RData")
load("./data/twittertestphrases.RData")
load("./data/blogstestphrases.RData")

#### Prediction Model MLE

evaluation_merged_MLE<-batch_evaluation2(qgram_phrase,qgram_result)
evaluation_result_blgs_MLE<-batch_evaluation2(blgs_testphrase,blgs_test_result)
evaluation_result_nws_MLE<-batch_evaluation2(nws_testphrase,nws_test_result)
evaluation_result_twts_MLE<-batch_evaluation2(twts_testphrase,twts_test_result)

evaluation_result_twts_MLE$data_set<-"Twitter"
evaluation_result_blgs_MLE$data_set<-"Blogs"
evaluation_result_nws_MLE$data_set<-"News"
evaluation_merged_MLE$data_set<-"Merged Data"


eval_MLE<-rbind(rbind(rbind(evaluation_result_twts_MLE,evaluation_result_blgs_MLE),evaluation_result_nws_MLE),evaluation_merged_MLE)

save(eval_MLE,evaluation_merged_MLE,evaluation_result_twts_MLE,evaluation_result_blgs_MLE,evaluation_result_nws_MLE,file="./data/evaluation_results_MLE.RData")


#### PREDICTION Model KN

evaluation_results_test_kn<-batch_evaluation2(qgram_phrase,qgram_result)

evaluation_result_blgs_kn<-batch_evaluation2(blgs_testphrase,blgs_test_result)
evaluation_result_nws_kn<-batch_evaluation2(nws_testphrase,nws_test_result)
evaluation_result_twts_kn<-batch_evaluation2(twts_testphrase,twts_test_result)

save(evaluation_results_test_kn,evaluation_result_twts_kn,evaluation_result_blgs_kn,evaluation_result_nws_kn,file="./data/evaluation_results_KN.RData")


### MERGE RESULTS KN

setkey(evaluation_result_blgs_kn,part_id)
setkey(evaluation_result_nws_kn,part_id)
setkey(evaluation_result_twts_kn,part_id)
names(evaluation_result_blgs_kn)<-c("part_id","blgs_kn")
names(evaluation_result_nws_kn)<-c("part_id","news_kn")
names(evaluation_result_twts_kn)<-c("part_id","twts_kn")

kn_eval<-merge(evaluation_result_blgs_kn,evaluation_result_nws_kn)
setkey(kn_eval,part_id)
kn_eval<-merge(kn_eval,evaluation_result_twts_kn)

save(kn_eval,file="./data/kn_eval.RData")




avg_accuracy<-data.table(nws_avg_accuracy=mean(MLE_eval$news_MLE),
						  twts_avg_accuracy=mean(MLE_eval$twts_MLE),
						  blgs_avg_accuracy=mean(MLE_eval$blgs_MLE))
						  
accuracy_mean_sd<-data.table(nws_mean=mean(MLE_eval$news_MLE),nws_sd=sd(MLE_eval$news_MLE),
						  twts_mean=mean(MLE_eval$twts_MLE),twts_sd=sd(MLE_eval$twts_MLE),
						  blgs_mean=mean(MLE_eval$blgs_MLE),blgs_sd=sd(MLE_eval$blgs_MLE)
						  )


accuracy_mean_sd$nws_mean + c(-1,1)*1.96*accuracy_mean_sd$nws_sd/sqrt(1000)
[1] 16.72356 17.02625
accuracy_mean_sd$twts_mean + c(-1,1)*1.96*accuracy_mean_sd$twts_sd/sqrt(1000)
[1] 15.71658 16.00812
accuracy_mean_sd$blgs_mean + c(-1,1)*1.96*accuracy_mean_sd$blgs_sd/sqrt(1000)
[1] 16.25942 16.56169


ggplot(MLE_eval,aes(x=news_MLE)) +labs(x="mean accuracy of prediction")+   geom_histogram(aes(y = ..density..),fill='blue',binwidth=0.25) + 
    geom_vline(data=accuracy_mean_sd, aes(xintercept=nws_mean),color=c("red")) +geom_density(alpha=.3,fill='red')	+ 
    ggtitle("The distribution of average NWP accuracy of 250 news phrases - 2000 Test Samples") + 
    theme(plot.title = element_text(lineheight=.8,size=8))	

ggplot(MLE_eval,aes(x=twts_MLE)) +labs(x="mean accuracy of prediction")+   geom_histogram(aes(y = ..density..),fill='blue',binwidth=0.25) + 
    geom_vline(data=accuracy_mean_sd, aes(xintercept=twts_mean),color=c("red")) +geom_density(alpha=.3,fill='red')	+ 
    ggtitle("The distribution of average NWP accuracy of 250 twitter phrases - 2000 Test Samples") + 
    theme(plot.title = element_text(lineheight=.8,size=8))	
	
ggplot(MLE_eval,aes(x=blgs_MLE)) +labs(x="mean accuracy of prediction")+   geom_histogram(aes(y = ..density..),fill='blue',binwidth=0.25) + 
    geom_vline(data=accuracy_mean_sd, aes(xintercept=blgs_mean),color=c("red")) +geom_density(alpha=.3,fill='red')	+ 
    ggtitle("The distribution of average NWP accuracy of 250 blog phrases - 2000 Test Samples") + 
    theme(plot.title = element_text(lineheight=.8,size=8))	  	

############# Visualization of accuracy

names(evaluation_result_blgs_MLE)<-c("part_id","accuracy")
names(evaluation_result_nws_MLE)<-c("part_id","accuracy")
names(evaluation_result_twts_MLE)<-c("part_id","accuracy")

evaluation_result_twts_MLE$data_set<-"Twitter"
evaluation_result_blgs_MLE$data_set<-"Blogs"
evaluation_result_nws_MLE$data_set<-"News"
evaluation_merged_MLE$data_set<-"Merged Data"


eval<-rbind(rbind(rbind(evaluation_result_twts_MLE,evaluation_result_blgs_MLE),evaluation_result_nws_MLE),evaluation_merged_MLE)

boxplot(accuracy~data_set,xlab = "Data Type",
	ylab = "Average Single Word Prediction Accuracy (%)",
	main = "Average Prediction Accuracy - 2000 Test Sets (250 phrases each)",data=eval, 
	cex.lab=0.9,cex.main=0.9, cex.axis=0.9,
	col=c("orange","blue","lightblue","lightgreen"),las=1,outline=FALSE)
	
####################
### MERGE RESULTS MLE

names(evaluation_result_blgs_MLE)<-c("part_id","blgs_MLE")
names(evaluation_result_nws_MLE)<-c("part_id","news_MLE")
names(evaluation_result_twts_MLE)<-c("part_id","twts_MLE")

setkey(evaluation_result_blgs_MLE,part_id)
setkey(evaluation_result_nws_MLE,part_id)
setkey(evaluation_result_twts_MLE,part_id)

MLE_eval<-merge(evaluation_result_blgs_MLE,evaluation_result_nws_MLE)
setkey(MLE_eval,part_id)
MLE_eval<-merge(MLE_eval,evaluation_result_twts_MLE)

save(MLE_eval,file="./data/MLE_eval.RData")	