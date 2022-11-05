



#Creating a dataframe form the WorldPhone dataset


myData = read.csv("neiss.csv", TRUE, sep = ",")
dfData = data.frame(myData)

dfData = dfData[10:20,]


# setting the df.pid to rownames(myData)  / rownames(dfData) 
dfData$pid = rownames(dfData)


  
################################# 
#################################
#################################
#########    UI    ##############
#################################
#################################
#################################
#################################
  
  # Use a fluid Bootstrap layout
  
ui <-  fluidPage(theme="d3style.css",
            
            # Give the page a title
            titlePanel("Testing D3 v1"),
            
            
            
            
            
            sliderInput(inputId = "slider", label = "Select a number:", min = 0.01, max = 3, value = 0.3, step = 0.01),
            textOutput(outputId = "result"),
            
            
            
            # Generate a row with a sidebar
            sidebarLayout(      
              
              # Define the sidebar with one input
              sidebarPanel(
                selectInput("bodyPart", "Body Part injured:", 
                            choices= unique(dfData$body_part)),    #colnames(WorldPhones)),
                hr(),
                helpText("Source data"),
                
                
                textInput("caption", "Caption:", "Data Summary"),
                
                
                textInput("TEXT1", "tEXT:", "Data Summary"), 
                
                
                actionButton("goButton", "Go"),
              ),
              
              # main panel where we will show the d3 plot
              mainPanel(
                
                # it will load the d3.js of version 5 in html from cdn
                tags$head(tags$script(src="https://d3js.org/d3.v5.min.js")),
                tags$head(tags$script(src="https://d3js.org/d3-scale-chromatic.v1.min.js")),
                
                
                # this is the script where we create our d3 chart, which resides in www folder
                #tags$script(src="testd3js.js"),
                tags$script(src="d3js.js"),
                
                # place for d3 chart
                plotOutput("D3Plot"),
                
                # Text part shown based on shiny control side panel
                #h3(textOutput("TEXT1", container="click on the circle to lock output text to foo value")),
                div("Some Examples -  ", class="someClass"),
                div("Some Other examples -  ", class="otherClass"),
                
                h3(textOutput("caption", container = span)),
                h3(textOutput("TEXT1", container = span))
                #div("Somee text", class="someClass", 
                #    tags$input(type="submit", value="Dismiss")
                #)
                
              )
              
            )
  )

#################################
#################################
#################################
#########  SERVER  ##############
#################################
#################################
#################################
#################################


# Define a server for the Shiny app
server <- function(input, output,session) {
  

   
  observe({
    
    # this is act as a listener. Once the R (shiny drop down is changed) the corresponding d3 elements,
    # buttons that are bind to R input$region value will also be change. 
    
    # to send the data 2 javascript we will use session$sendCustomMessage
    # the type = 'dataNAME' ,we can give any name here but it must be match with d3js.js file                                      #,"nums"=input$foo         
   # payload1 <- data.frame(cbind('id'=c('one','two','three','four'),'y'=input$bodyPart,'val'=input$slider))
   # session$sendCustomMessage(type='sentMsg', jsonlite::toJSON(payload1))
    
    payload2 <- data.frame(cbind('slider'=input$slider,'body_part' = input$bodyPart,"age"=dfData[,"age"]))
     session$sendCustomMessage(type='r-data2-d3', jsonlite::toJSON(payload2))

    
    #input$slider
    #session$sendCustomMessage(type='sliderValue', jsonlite::toJSON(data.frame(cbind('val'=input$slider))))
    
    output$result <- renderText({
      input$slider
      
    })
    
  })
  
  
  
  cap <- eventReactive(input$goButton, {
    input$caption
  })
  
  text <- eventReactive(input$goButton, {
    #input$TEXT1
    # If circles in d3 clicked then the go button from Rshiny updates the dom with new text
    # This can be helpful in running any R code and outputing the result to screen in Text format
      input$foo 
   
    
  })
  
  
  output$caption <- renderText({
    cap()
  })
  
  output$TEXT1 <- renderText({
    text()
  })
  
  
}


shinyApp(ui=ui, server=server)