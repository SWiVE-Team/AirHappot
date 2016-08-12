library(shiny)
library(openxlsx)
source("global.R")

# Define a server for the Shiny app
shinyServer(function(input, output) {

#   distInput <- reactive({
#     switch(input$district,
#            "中埔鄉"="Zongpu",
#            "竹崎鄉"="Zhuqi",
#            "梅山鄉"="Meishan")
#   })
 
  # Fill in the spot we created for a plot
  output$hooksPlot <- renderPlot({
    # Render a barplot
    barplot(hooksTable[,input$district], 
            #main=sprintf("%s %s", "Chiayi", distInput),
            #main = sprintf("%s %s", "Chiayi", input$district),
            ylab = "Number of Hook",
            xlab = "Month")
  })
  
  output$text <- renderText({
    paste("Specialty in ",input$district,": umbrella")
  })
  
  output$downloadData <- downloadHandler(
    filename = function(){
      paste('ChiayiHookData-', Sys.Date(), '.csv', sep='')
    },
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
      
      # write the file specified by the 'filetype' argument
      write.table(hooksTable, file, sep = sep, row.names = FALSE)
    }
  )
})


