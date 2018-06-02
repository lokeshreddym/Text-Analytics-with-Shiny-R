library("shiny")

shinyUI(fluidPage(
  
  titlePanel("Building a Shiny App around the UDPipe NLP workflow"), # end of title panel
  
  sidebarLayout(
    sidebarPanel(
      # Input: Select a file ----
      fileInput("file", "Choose File"),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Select number of rows to display ----
      radioButtons("disp", "Select File Type",
                   choices = c(PDF = "PDF",
                               Text = "Text"),
                   selected = "PDF"),
      
    
    textInput("Path", "Upload english model location along with model and extension"),
      checkboxGroupInput("Checkbox","Select required UPOS for co-occurance plot",
                         choices = c("ADJ","NOUN","PROPN","ADV","VERB"),
                         selected = c("ADJ","NOUN","PROPN")) ,
      downloadButton("Download","Download Annotated dataset with required extension"," ")
      
               ), #end of sidebar panel

    
    mainPanel(
      
      tabsetPanel(type = "tabs",   # builds tab struc
                  
                  tabPanel("Overview",   # leftmost tab
                           
                           h4(p("Data input")),
                           
                           p("This app supports only pdf file for NLP processing.", align="justify"),
                           
                           br(),
                           
                           h4('How to use this App'),
                           
                           p('To use this app, click on', 
                             span(strong("Upload any text document")),
                             'You can also choose english model and POS for which you want to build co-occurance plot',
                              'and you have data cloud for nouns and verbs.')),
                  
                  # second tab coming up:
                  tabPanel("Annotated documents",
                           
                           tableOutput('Andoc')),
                           
                  
                  # third tab coming up:
                  tabPanel("Data cloud",
                           
                         plotOutput('Data_cloudn'),plotOutput('Data_cloudv')),
                         
                  
                  # fourth tab coming up:
                  tabPanel("Co-occ",
                           
                           plotOutput('Co_oc'))
                  
               
                  
) # end of tabsetPanel
) # end of mail panel
) #end of sidebar layout
) #end of fluidpage
) # end of shinyUI



  
