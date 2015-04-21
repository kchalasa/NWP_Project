load("./data/testphrases.RData")
load("./data/newstestphrases.RData")
load("./data/twittertestphrases.RData")
load("./data/blogstestphrases.RData")

#### Invoke Prediction Merged Data, Blogs, News and Twitter

evaluation_merged_MLE<-batch_evaluation2(qgram_phrase,qgram_result)
evaluation_result_blgs_MLE<-batch_evaluation2(blgs_testphrase,blgs_test_result)
evaluation_result_nws_MLE<-batch_evaluation2(nws_testphrase,nws_test_result)
evaluation_result_twts_MLE<-batch_evaluation2(twts_testphrase,twts_test_result)

## Data Type to the data evaluated
evaluation_result_twts_MLE$data_set<-"Twitter"
evaluation_result_blgs_MLE$data_set<-"Blogs"
evaluation_result_nws_MLE$data_set<-"News"
evaluation_merged_MLE$data_set<-"Merged Data"

## Merge Results for analysis 1
save(evaluation_merged_MLE,evaluation_result_twts_MLE,evaluation_result_blgs_MLE,evaluation_result_nws_MLE,file="./data/evaluation_results_MLE.RData")

###################################
#  Visualization of accuracy 1
###################################

eval<-rbind(rbind(rbind(evaluation_result_twts_MLE,evaluation_result_blgs_MLE),evaluation_result_nws_MLE),evaluation_merged_MLE)

boxplot(accuracy~data_set,xlab = "Data Type",
	ylab = "Average Single Word Prediction Accuracy (%)",
	main = "Average Prediction Accuracy - 2000 Test Sets (250 phrases each)",data=eval, 
	cex.lab=0.9,cex.main=0.9, cex.axis=0.9,
	col=c("orange","blue","lightblue","lightgreen"),las=1,outline=FALSE)

##############################################
### Prepare Data for Analysis 2
##############################################

names(evaluation_result_blgs_MLE)<-c("part_id","blgs_MLE")
names(evaluation_result_nws_MLE)<-c("part_id","news_MLE")
names(evaluation_result_twts_MLE)<-c("part_id","twts_MLE")

setkey(evaluation_result_blgs_MLE,part_id)
setkey(evaluation_result_nws_MLE,part_id)
setkey(evaluation_result_twts_MLE,part_id)

eval_combined_mle<-evaluation_merged_MLE[,c(1,2)]
setkey(eval_combined_mle,part_id)

MLE_eval<-merge(evaluation_result_blgs_MLE,evaluation_result_nws_MLE)
setkey(MLE_eval,part_id)
MLE_eval<-merge(MLE_eval,evaluation_result_twts_MLE)

MLE_eval<-merge(MLE_eval,eval_combined_mle)

save(MLE_eval,file="./data/MLE_eval.RData")	

						  
accuracy_mean_sd<-data.table(nws_mean=mean(MLE_eval$news_MLE),nws_sd=sd(MLE_eval$news_MLE),
						  twts_mean=mean(MLE_eval$twts_MLE),twts_sd=sd(MLE_eval$twts_MLE),
						  blgs_mean=mean(MLE_eval$blgs_MLE),blgs_sd=sd(MLE_eval$blgs_MLE),
						  combined_mean=mean(MLE_eval$accuracy),combined_sd=sd(MLE_eval$accuracy)
						  )

## Compute Confidence Interval for Accuracy

accuracy_mean_sd$nws_mean + c(-1,1)*1.96*accuracy_mean_sd$nws_sd/sqrt(1000)
[1] 16.72356 17.02625
accuracy_mean_sd$twts_mean + c(-1,1)*1.96*accuracy_mean_sd$twts_sd/sqrt(1000)
[1] 15.71658 16.00812
accuracy_mean_sd$blgs_mean + c(-1,1)*1.96*accuracy_mean_sd$blgs_sd/sqrt(1000)
[1] 16.25942 16.56169
accuracy_mean_sd$combined_mean + c(-1,1)*1.96*accuracy_mean_sd$combined_sd/sqrt(1000)


###################################
#  Visualization of accuracy 1
###################################


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
	
ggplot(MLE_eval,aes(x=accuracy)) +labs(x="mean accuracy of prediction")+   geom_histogram(aes(y = ..density..),fill='blue',binwidth=0.25) + 
    geom_vline(data=accuracy_mean_sd, aes(xintercept=blgs_mean),color=c("red")) +geom_density(alpha=.3,fill='red')	+ 
    ggtitle("Distribution of Average Prediction Accuracy of Combined data - 2000 Test Samples(250 phrases each)") + 
    theme(plot.title = element_text(lineheight=.8,size=8,face="bold"))

