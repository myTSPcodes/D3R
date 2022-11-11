

library(biclust)
library(tidyverse)
#Creating a dataframe form the WorldPhone dataset


myData = read.csv("https://raw.githubusercontent.com/holtzy/D3-graph-gallery/master/DATA/heatmap_data.csv", TRUE, sep = ",")
healthData = read.csv("health.csv", TRUE, sep = ",", stringsAsFactors = TRUE, nrow = 100)
dfData = data.frame(myData)
dfHData = data.frame(healthData[0:100,])


tujuh <- matrix(c(1,0,0,0,0,0,0,0,0,1,
                  0,0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,0,
                  0,0,1,0,1,0,0,0,0,0,
                  0,0,0,1,0,0,0,0,0,0,
                  0,0,1,0,1,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,0,
                  1,0,0,0,0,0,0,0,0,1),
                nrow = 10,
                ncol = 10,
                byrow = TRUE)
colnames(tujuh)<-c("A","B","C","D","E","F","G","H","I","J")
rownames(tujuh)<-c("P","S","O","T","U","V","W","X","Y","Z")


tujuh.bimax <- biclust(tujuh, method=BCBimax())

## slicing to get small portion of data
## dfData = dfData[10:20,]


# setting the df.pid to rownames(myData)  / rownames(dfData) 
dfData$pid = rownames(dfData)
dfHData$pid = rownames(dfHData)
  

## Returns the first parts of the data frame

## Returns the latter parts of the data frame
# tail(dfHData)
## Compactly display the internal structure of the data frame
#  str(dfHData)
## Summarize medical expenses
#  summary(dfHData$expenses)
## Histogram of medical expenses
# hist(dfHData$expenses)
## Table of region
#  table(dfHData$region)
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
            titlePanel("no confusion matrix"),
            hr(),
            hr(),
            helpText("Connected R [app.R] and d3 [d3.js]"),
            helpText("Sent data from R to d3 into a matrix"),
            helpText("We have two sliders that can use user input into our json object"),
            helpText("But none of these can change the underlying data or working copy of that data ad hoc !"),
            
            sliderInput(inputId = "sliderData", label = "Select number data:", min = 0, max = 10, value = 1, step = 1),
            textOutput(outputId = "result3"),
            
            sliderInput(inputId = "slider2", label = "Select number of features (columns):", min = 0, max = 10, value = 10, step = 1),
            textOutput(outputId = "result2"),
            
            
            
            sliderInput(inputId = "slider1", label = "Select number of rows:", min = 0, max = 10, value = 10, step = 1),
            textOutput(outputId = "result"),
            
    
            
            # Generate a row with a sidebar
            sidebarLayout(      
              position = "right",
              # Define the sidebar with one input
              sidebarPanel(
                selectInput("userSelection", "Choose your Y axis:", 
                            choices= unique(dfHData$sex)),    #colnames(WorldPhones)),
                hr(),
                helpText("Select some rectangles and then click go to see which ones has been choosen"),
                helpText("Setting data in R using interaction with d3"),
                
                actionButton("goButton", "Go"),
                
                textInput("varNum", "Variable number:", "5"),
                
                
                textInput("grpCat", "Group Category:", "25"), 
                hr(),
                
                helpText("Your selected cell address:"),
                
                tags$div(id = 'placeholder1')
               
              ),
              
              # main panel where we will show the d3 plot
              mainPanel(
                
                # it will load the d3.js of version 5 in html from cdn
                tags$head(tags$script(src="https://d3js.org/d3.v5.min.js")),
                tags$head(tags$script(src="https://d3js.org/d3-scale-chromatic.v1.min.js")),
                
                ## Returns the first parts of the data frame
      
                # this is the script where we create our d3 chart, which resides in www folder
                ## default js is 
               ##tags$script(src="d3js.js"),
               
               tags$script(src="testd3js.js"),
               
               
                
                # place for d3 chart
                plotOutput("D3Plot"),
               plotOutput("D3Plot2"),
               plotOutput('Hist'),
               h3(textOutput("Summary")),
              
                # Text part shown based on shiny control side panel
                #h3(textOutput("TEXT1", container="click on the circle to lock output text to foo value")),
                div("some text", class="someClass"),
                div("Some Other examples -  ", class="otherClass"),
                div('empty', class="div_template"),
               
                # caption , TEXT1 and d3variable are actual variable names comming from d3/Rbackned
                h3(textOutput("varNum", container = span)),
                h3(textOutput("grpCat", container = span)),
               h3(textOutput("d3variable", container = span))
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
  
 # head(healthData)
  ## Returns the latter parts of the data frame
  #tail(healthData)
  ## Compactly display the internal structure of the data frame
 # str(healthData)
  ## Summarize medical expenses
#  summary(healthData)
  ## Histogram of medical expenses
 
  ## Table of region
#  table(healthData$region)
   
  observe({
    
    # this is act as a listener. Once the R (shiny drop down is changed) the corresponding d3 elements,
    # buttons that are bind to R input$region value will also be change. 
    # to send the data 2 javascript we will use session$sendCustomMessage
    
    
    payload <- data.frame(cbind('var' = input$sliderData , 'cat'= input$grpCat, 'slider2'=input$slider2, 'slider1'=input$slider1,'variable' = dfData[,"variable"],
                                "group"= dfData[,"group"], "value"= dfData[,"value"],
                                #"group"=tujuh[,1:10],"value"=tujuh[1:10,],
                                'id' = dfHData$pid[1:10]
                             #   'sex' = dfHData[,"sex"][1:100],
                              #  'bmi' = dfHData[,"bmi"][0:10],
                             #   'children' = dfHData[,"children"][0:10],
                             #   'smoker' = dfHData[,"smoker"][0:10],
                             #  'region' = dfHData[,"region"][0:10],
                            #    'expenses' = dfHData[,"expenses"][0:10]
                          
                                ))
    
    session$sendCustomMessage(type='r-data2-d3', jsonlite::toJSON(payload))

    
    #input$slider
    #session$sendCustomMessage(type='sliderValue', jsonlite::toJSON(data.frame(cbind('val'=input$slider))))
    
    
    output$Hist <- renderPlot({hist(rnorm(100,input$slider2,1))})
    
    output$Summary <- renderText({
      #summary(healthData)
      #summary(
     # summary(lm( df$x ~  df$y ))
      #)
    }
    )
                              
    output$result <- renderText({
      input$slider

    })
    
  })
  
  clicks <- eventReactive(input$goButton, {
    input$d3variable
    
  })
  
  var <- eventReactive(input$goButton, {
    input$varNum
  })
  
  grp <- eventReactive(input$goButton, {
    input$grpCat
  })
  
  run <- eventReactive(input$goButton, {
    #input$TEXT1
    # If circles in d3 clicked then the go button from Rshiny updates the dom with new text
    # This can be helpful in running any R code and outputing the result to screen in Text format
    #  input$foo 
   c("id2:",input$userSelection,
   #   "age:",(dfHData[,"age"])[as.integer(input$userSelection)], 
   #   " bmi:", dfHData[,"bmi"][as.integer(input$userSelection)],
      " V:", dfData[,"variable"][as.integer(input$varNum)],
      " G:", dfData[,"group"][as.integer(input$grpCat)]
      )
    
  })
  
  
  output$d3variable <- renderText({
    clicks()
    run()
  })
  
  
  output$varNum <- renderText({
    #var()
  })
  
  output$grpCat <- renderText({
    #grp()
    
  })
  
  

  
  
}


shinyApp(ui=ui, server=server)