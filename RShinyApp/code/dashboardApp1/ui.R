library(shiny)
library(data.table)
library(plotly)
source("global.R")

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Hooks of district"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("region", "Region:", 
                    choices=c("嘉義縣", "臺南市", "高雄市")),
        selectInput("district", "District:", 
                    choices=c("中埔鄉", "竹崎鄉", "梅山鄉")),
        hr(),
        helpText("Data from all of our sharing."),
        hr(),
        radioButtons("filetype", "File type:",
                     choices = c("csv", "tsv")),
        downloadButton('downloadData', 'Download')
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("hooksPlot"),
        verbatimTextOutput("text")
      )

    )
  )
)

