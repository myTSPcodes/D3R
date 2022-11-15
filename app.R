

myData = read.csv("https://raw.githubusercontent.com/holtzy/D3-graph-gallery/master/DATA/heatmap_data.csv", TRUE, sep = ",")
dfData = data.frame(myData)
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
            titlePanel("No Confusion Matrix "),
            helpText("Connected R [app.R] and d3 [d3.js]"),
            helpText("Sent data from R to d3 into a matrix"),
            helpText("We have two sliders that can use user input into our json object"),
            helpText("But none of these can change the underlying data or working copy of that data ad hoc !"),
            sliderInput(inputId = "slider2", label = "Select number of features (columns):", min = 0, max = 10, value = 10, step = 1),
            textOutput(outputId = "result2"),
            sliderInput(inputId = "slider1", label = "Select number of rows:", min = 0, max = 10, value = 10, step = 1),
            textOutput(outputId = "result"),
  
            # Generate a row with a sidebar
            sidebarLayout(      
              
              # Define the sidebar with one input
              sidebarPanel(
                
                hr(),
                # Text part shown based on shiny control side panel
                #div("Some Examples -  ", class="caption"),
                div(textOutput("caption", container = span)),
                #div('empty', class="div_template"),
                
                h3(textOutput("caption2", container = span)),
                h3(textOutput("TEXT1", container = span)),
                
                selectInput("userSelection", "Choose your Y axis:", 
                            choices= unique(dfData$variable)),    #colnames(WorldPhones)),
                hr(),
                helpText("Select some rectangles and then click go to see which ones has been choosen"),
                helpText("Setting data in R using interaction with d3"),
                actionButton("goButton", "Go"),
                actionButton("cleanButton", "clean"),
                textInput("caption", "Caption:", "Data Summary"),
                textInput("TEXT1", "tEXT:", "Data Summary"), 
                hr(),
                helpText("Your selected cell address:"),
                tags$div(id = 'placeholder1')
              ),
              
              # main panel where we will show the d3 plot
              mainPanel(
                
                # it will load the d3.js of version 5 in html from cdn
                tags$head(tags$script(src="https://d3js.org/d3.v5.min.js")),
                tags$head(tags$script(src="https://d3js.org/d3-scale-chromatic.v1.min.js")),
               tags$script(src="testd3js.js"),
      
                # place for d3 chart
                plotOutput("D3Plot"),
                
             
                # caption , TEXT1 and d3variable are actual variable names comming from d3/Rbackned
               
                
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
    # TO GET the input from user use : 'variable' = input$userSelection
     payload2 <- data.frame(cbind('slider2'=input$slider2, 'slider1'=input$slider1,'variable' = dfData[,"variable"],"group"=dfData[,"group"],"value"=dfData[,"value"]))
     session$sendCustomMessage(type='r-data2-d3', jsonlite::toJSON(payload2))

    
    output$result <- renderText({
      input$slider

    })
    
  })
  
  clicks <- eventReactive(input$goButton, {
    input$d3variable
  })
  

  
  cap <- eventReactive(input$goButton, {
    input$caption
  })
  
  text <- eventReactive(input$goButton, {
    input$TEXT1
    # If circles in d3 clicked then the go button from Rshiny updates the dom with new text
    # This can be helpful in running any R code and outputing the result to screen in Text format
     # input$foo 
    
  })
  
  
  output$d3variable <- renderText({
    clicks()
  })

  
  output$caption <- renderText({
    cap()
  })
  
  output$TEXT1 <- renderText({
    text()
  })
  
}


shinyApp(ui=ui, server=server)