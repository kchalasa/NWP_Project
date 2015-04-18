## #######################################################
## Date: 04/17/2015
## Author: Kanti Chalasani
## Description: This Script defines the USER INTERFACE for shiny Next Word Prediction Application
##########################################################

library(shiny)


shinyUI(fluidPage(
  fluidRow(column(12,h2("Next Word Prediction Application")
    )
  ),
  fluidRow(column(6, wellPanel(style = "background-color: lightblue;",
      h4("Enter a text phrase"),
      tags$textarea(name="phrase", id="phrase", rows=3, cols=60,"How are you"),
      br(),
      actionButton("txtreset", "Reset")
      )),
 column(3,
        wellPanel(style = "background-color: lightblue;",h4("Predicted Next Word- Click to accept:"),
                  br(),
   uiOutput("prediction1") ,
   textOutput("text1"),
   tags$input(id = "pred1", type = "text", value = "",style="display:none;"),
   tags$input(id = "pred2", type = "text", value = "",style="display:none;"),
   tags$input(id = "pred3", type = "text", value = "",style="display:none;"),
   tags$input(id = "pred4", type = "text", value = "",style="display:none;"),
   br(),br()

  ))) ,
 fluidRow(column(6,plotOutput("chart1")),
          column(3,wellPanel(style = "background-color: lightblue;",
                            tags$div(class="header",
                            checked=NA,
                            list(
                              br(),
                              tags$a(href="http://www.google.com","Help / Background Information",style="font-size: 16px; color : black"),
                              br(), br(),
                              tags$a(href="http://www.google.com","Access Source Code",style="font-size: 16px; color : black"),
                              br(), br(),
                              tags$a(href="mailto:kanti.chalasani@gmail.com","Contact Author",style="font-size: 16px; color : black"),
                              br(), br()
                              )))))
))