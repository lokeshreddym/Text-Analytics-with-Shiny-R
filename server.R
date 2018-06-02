library("shiny")
library("igraph")
library("ggplot2")
library("tm")
library("udpipe")
library("stringr")
library("pdftools")
library("tidyverse")
library("tidytext")
library("wordcloud")
library('readr')
library('utf8')
library('stringr')



shinyServer(
  function(input,output){
    
    indata <- reactive({
      
      
      req(input$file)
      
      if(input$disp == "PDF") {
        nokia = pdf_text(input$file$datapath)
        nokia  =  str_replace_all(nokia, "<.*?>,:/", "") # get rid of html junk 
        str(nokia)
        nokia1  <- removePunctuation(nokia)
        return(nokia1)
      }
      else if (input$disp == "Text") {
        nokia = read_lines(input$file$datapath)
        nokia  =  str_replace_all(nokia, "<.*?>,:/", "") # get rid of html junk 
        str(nokia)
        nokia1  <- removePunctuation(nokia)
        nokia1<-na.omit(nokia1)
        return(nokia1)
      }
      
      
    })
    
    
    x <- reactive ({
    
    # load english model for annotation from working dir
    english_model = udpipe_load_model(input$Path)  # file_model only needed
    
    # now annotate text dataset using ud_model above
    # system.time({   # ~ depends on corpus size
    x <- udpipe_annotate(english_model, x = indata() )
    x <- as.data.frame(x)
    #	})  # 13.76 secs
    return(x)
    })
    
    output$Data_cloudn <- renderPlot({
    # So what're the most common nouns? verbs?
    all_nouns = x() %>% subset(., upos %in% "NOUN") 
    all_nouns<-all_nouns[-which(is.na(all_nouns)),]
    
      all_nouns %>%
        count(lemma) %>%
        with(wordcloud(lemma, n, max.words = 10000))
    })
 
    
    output$Data_cloudv <- renderPlot({
      all_verbs = x() %>% subset(., upos %in% "VERB") 
      all_verbs<-all_verbs[-which(is.na(all_verbs)),]
      all_verbs %>%
        count(lemma) %>%
        with(wordcloud(lemma, n, max.words = 10000))
  
    })
    
    
    output$Co_oc <- renderPlot({
      
           # general (non-sentence based) Co-occurrences
      nokia_cooc_gen_napav <- cooccurrence(x= x()$lemma,
                                           relevant = x()$upos %in% c(input$Checkbox)) # 0.00 secs
     
      cooc_g <- nokia_cooc_gen_napav[1:30,]
      
      
      graph <- graph.adjacency(as.matrix(cooc_g, cooc),
                               weighted=TRUE,
                               diag=FALSE)
      
      
      plot(graph,
           
           vertex.label=cooc_g$term1,
           vertex.size=cooc_g$cooc,
           edge.width=E(graph)$weight)
        })
    
    
    
    
    
    output$Andoc <- renderTable({
      
      k <- x()
      
      y <- k[1:100,c(1,2,3,5,6,7,8,9,10,11,12,13,14)]
      
    })
    
    
    output$Download <- downloadHandler( 
      
      filename = function(){
        paste("data-", ".csv", sep=" ")
      },
      
      content <- function(file) {
        
        write.csv(x(),file) 
        
      }
    
    )
    
    }
    )
    
  

