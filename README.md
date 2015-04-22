# NWP_Project
Next Word Prediction - Natural Language Processing Application for Coursera Data Science Specialization

1. To access "Next Word Prediction" Application - [click here](http://kchalasa.shinyapps.io/NWP_Application/)
2. To access "Next Word Prediction" Presentation - [click here](http://rpubs.com/kchalasa/nwp)
3. To access "Next Word Prediction" Exploratory Analysis Report - [click here](http://rpubs.com/kchalasa/nlpmilestone)


**NWP_Application**
To deploy this application on your local machine please follow the following steps in the order listed below:

- Connect to R Console or RSTUDIO
- Make sure these libraries are installed
  + shiny
  + data.table
  + ggplot2
- Download the contents of NWP_Application into your current working directory
- source("Predict_Next_Word.R")
- Run Shiny Application
	shiny::runApp()
- Run Manually  
  + predict_next_word("how are you")          # Returns a data.table of up to four words [prob (probability); word (predicted next word); ngram (ngram used in prediction)]
  + predict_single_word("how are you")        # Returns Single word
  
  
**Presentation**
This folder contains the presentation files for this application.

**Ngrams**
Reproducible R scripts used in building and evaluating this model are included here.  README markdown included in this folder specifies the order of execution. 
Source data from [HC Corpora](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) will need to be downloaded and unzipped into the
data folder of current working directory where these scripts are saved. 
 
 **exploratoryDataAnalysis**
 
 This folder contains the scripts used in generating milestone report on exploratory data analysis. Ngrams for exploratory analysis 
 were generated using TM and RWeka packages in R.
 
 


