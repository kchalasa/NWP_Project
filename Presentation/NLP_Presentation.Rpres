Next Word Predictor
========================================================
author: Kanti Chalasani
date: 04/26/2015

Next Word Prediction application suggests the possible next word in a sentence as the users types them on their smart devices.
<style type="text/css">

.reveal .state-background {
   background: lightgrey;
   top: 0%;
   background-repeat:no-repeat;
   margin:5 0% 0% 0%;
  padding:0% 0% 0% 0%;
}

.section .reveal .state-background {
   background: grey;
   background-repeat:no-repeat;
  margin:0% 0% 0% 0%;
  padding:0% 0% 0% 0%;
}

.sub-section .reveal .state-background {
   background: lightgrey;
   background-repeat:no-repeat;
   margin:0% 0% 0% 0%;
  padding:0% 0% 0% 0%;
}

.small-code pre code {
font-size: 1.3em;
}
</style>

========================================================


#### **Next Word Prediction (NWP) Application - PREVIEW !!**
<small style="font-size:.9em">
NWP Application is very easy to use as you can see below. 

![Application] (figures/NWP.JPG)

Access this application [here](https://kchalasa.shinyapps.io/NWP_Application/).
Access the source code [here](https://github.com/kchalasa/NWP_Project).

</small>

========================================================

#### **Data Processing**
<small style="font-size:.9em">

- News, Twitter and Blogs data in English from HC Corpora (over 4 million lines) are loaded .
- R Routines (utilities) built for data processing and data cleansing.
- Data Transformation(s) Applie: Few listed below
  + Expand English Word Contractions; remove HTML URLS;remove punctuation, trim whitespaces etc.
  + Remove EMOJI (emotional)/unicode/special/foreign character(s); convert corpus to lower case; 
- Random Data Sampling:
  + 70% Training - 70% from each type of data (twitter, news and blogs)
  + 30% Testing/Cross Validation - 30% from each type of data (twitter, news and blogs)

</small>

========================================================

#### **N-Grams - Language Model**
<small style="font-size:.8em">

- Build [ngram](http://en.wikipedia.org/wiki/N-gram) [language model](http://en.wikipedia.org/wiki/Language_model) on the merged training - "seen" data set.    
- The [conditional probability](http://en.wikipedia.org/wiki/Conditional_probability) of a word is defined by considering the frequency of the words preceding the word and its usage history in the document. 
  + p(awesome|This project is)= count(This project is awesome)/count(This project is)
- NGram reduction - Ngram model size was reduced by omitting the lower frequency ngrams.

**Prediction Algorithm** - [Katz Backoff](http://en.wikipedia.org/wiki/Katz%27s_back-off_model)

  + Get input phrase, clean and tokenize it
  + If phrase has three or more words, look for evidence in quadgrams (fourgrams), use it when evidence found; 
  + Otherwise backoff to trigram with highest conditional probability, use it when evidence found;
  + Otherwise backoff to bigram; otherwise use maximum likelihood estimate (MLE) of a partially matched unigram.
</small>

<small style="font-size:.8em">

========================================================

**Accuracy & Performance**
- Language Model evaluated by applying partitioned test sets from "unseen" test/validation data. Two thousand data partitions, each from news, blogs, twitter and combined data was used for evaluation. About 250 phrases were included in each partition.
 
 ![Accuracy1] (figures/Accuracy.JPG)
- 95% confidence interval for prediction accuracy of single word on combined data is between 15.4% and 15.7%. Prediction accuracy is about 26.8% on an average if we predict upto four next words.
- Prediction model predicts next word in about 0.03 secs.

</small>

