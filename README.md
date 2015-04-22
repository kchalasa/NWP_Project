# NWP_Project
Next Word Prediction - Natural Language Processing Application for Coursera Data Science Specialization

1. To access "Next Word Prediction" Application - [click here](http://kchalasa.shinyapps.io/NWP_Application/)
2. To access "Next Word Prediction" Presentation - [click here](http://rpubs.com/kchalasa/nwp)
3. To access "Next Word Prediction" Exploratory Analysis Report - [click here](http://rpubs.com/kchalasa/nlpmilestone)

#### Contents briefly described

**NWP_Application**
To deploy this application on to your local machine please follow the following steps below in the order of listing:

- Connect to R Console 
- Prerequisites - Libraries Required
  + shiny
  + data.table
  + ggplot2
- Download the contents of NWP_Application into your current working directory
- source("Predict_Next_Word.R")
- Run Shiny Application
	shiny::runApp()
- Run Manually  
  + predict_next_word("how are you")          &nbsp;&nbsp;&nbsp;# Returns a data.table of up to four words [prob (probability); word (predicted next word); ngram (ngram used in prediction)]
  + predict_single_word("how are you")        &nbsp;&nbsp;&nbsp;# Returns Single word
  
  
**Ngrams**
R scripts used in building and evaluating this model are included here.  README included specifies the order of execution of these scripts. 
Source data from [HC Corpora](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) will need to be downloaded and unzipped into the
data folder of current working directory where these scripts are saved. 
 
**Presentation**
This folder contains the presentation files for this application.

**exploratoryDataAnalysis**
 
 This folder contains the scripts used in generating milestone report on exploratory data analysis. Ngrams for exploratory analysis 
 were generated using TM and RWeka packages in R.
 
 


