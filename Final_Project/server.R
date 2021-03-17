library(shiny)
library(rsconnect)
library(dplyr)
library(tidyr)
library(tidyverse)
library(caret)
library(arules)
library(arulesViz)
library(ggplot2)


function(input, output){

  
  rules <- reactive(
    {
      req(input$file1)
      x = read.csv(input$file1$datapath, sep=",", dec=".", header=TRUE);
      
      datos_split <- split(x = x$Genre, f = x$Client);
      str(datos_split);
      transacciones <- as(datos_split, Class = "transactions");
      str(transacciones);
      
      soporte <- as.numeric(input$sup) / dim(transacciones)[1];
      income_rules <- apriori(data = transacciones,
                        parameter =list(supp= soporte,conf = as.numeric(input$conf) , minlen= as.numeric(input$len), maxlen = as.numeric(input$mlen),
                                                                                        maxtime=as.numeric(input$time), target = "rules"))

      
      #income_rules <- apriori(data=data, parameter=list (supp= as.numeric(input$sup),conf = as.numeric(input$conf) , minlen= as.numeric(input$len)+1, maxlen = as.numeric(input$mlen),
     #                                                    maxtime=as.numeric(input$time), target = "rules"), appearance = list (rhs=c("income=large", "income=small")))
    }
  )
  
  output$plot <- renderPlot({
    
    income_rules <-rules()
    
    p <- plot(income_rules)
    
    print (p)
  }, height = 600)
  
  output$rules <- renderDataTable( {
    
    income_rules <- rules()
    
    rulesdf <- DATAFRAME(income_rules)
    rulesdf
    
    
  })
  

  
  
}