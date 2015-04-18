## #######################################################
## Date: 04/17/2015
## Author: Kanti Chalasani
## Description: This Script defines the SERVER for shiny Next Word Prediction Application
##########################################################

source("helpers.R")
source("Predict_Next_Word.R")
library(ggplot2)

predicted<-""

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  
    observe({
              predicted<-""
              predicted_words<-""
              
              if (nchar(input$phrase)==0)  {
                  output$text1<-renderText({"Please enter a phrase for NEXT word prediction"})
                
                  output$prediction1<-renderUI({    
                    })
                  output$chart1<-renderPlot({
                     
                    })
              }
              
            
             if (nchar(input$phrase)!=0) {
                predicted_words <- predict_next_word(input$phrase)
                predicted<-unique(predicted_words$word)
              
              output$text1<-renderText({""})
             
              output$chart1<-renderPlot({
                if (nrow(predicted_words)>=1)
            
                  suppressWarnings(ggplot(data=predicted_words,aes(reorder(word,  prob*10000), prob*10000,fill=ngram,width=0.5))+  
                       geom_bar(stat="identity",position = "identity")+coord_flip()+
                       ylab("Transformed conditional Probability (times 1000) ") +
                       xlab("Predicted Word(s)") +
                  scale_fill_manual(values = c("fourgram" = "darkblue", "trigram" = "lightblue","bigram"="cyan","unigram"="green"))+
                  ggtitle("N-Grams used for Word Prediction") +
                    theme(axis.text=element_text(size=12),plot.title = element_text(size = rel(2),face="bold"),axis.title=element_text(size=14,face="bold"))
                    )
              })
              
              output$prediction1<-renderUI({  
                if (length(predicted)>=1)
                actionButton("predict1", label=predicted[1]) 
                                        })
            
                if (length(predicted)>=1)
                  updateTextInput(session, "pred1", value = predicted[1])
                
                if (length(predicted)>=2)
                updateTextInput(session, "pred2", value = predicted[2])
                
                if (length(predicted)>=3)
                updateTextInput(session, "pred3", value = predicted[3])
                
                if (length(predicted)>=4)
                updateTextInput(session, "pred4", value = predicted[4])
                
      
            }                 
      })
  observe ({
          if (input$txtreset >0) {
              isolate({
                input$txtreset
                updateTextInput(session, "phrase", value = "" )  
              })
          }
  })
  
  observe ({
    if (!is.null(input$predict1)) 
    if (input$predict1 > 0) {
      isolate({
          input$phrase
          sentence<-paste(input$phrase, input$pred1)
          updateTextInput(session, "phrase", value = sentence)
      })
    }
  })
  
  observe ({
    if (!is.null(input$predict1)) 
      if (input$predict1 > 0) {
        isolate({
          input$phrase
          sentence<-paste(mask_bad_words(input$phrase), input$pred1)
          updateTextInput(session, "phrase", value = sentence)
        })
      }
  })
  
  observe ({
    if (!is.null(input$predict2)) 
      if (input$predict2 > 0) {
        isolate({
          input$phrase
          sentence<-paste(mask_bad_words(input$phrase), input$pred2)
          updateTextInput(session, "phrase", value = sentence)
        })
      }
  })
  
  observe ({
    if (!is.null(input$predict3)) 
      if (input$predict3 > 0) {
        isolate({
          input$phrase
          sentence<-paste(mask_bad_words(input$phrase), input$pred3)
          updateTextInput(session, "phrase", value = sentence)
        })
      }
  })

  observe ({
    if (!is.null(input$predict4)) 
      if (input$predict4 > 0) {
        isolate({
          input$phrase
          sentence<-paste(mask_bad_words(input$phrase), input$pred4)
          print(sentence)
          updateTextInput(session, "phrase", value = sentence)
        })
      }
  })
  
})
