require(shiny)
require(leaflet)
#Define UI for the map and distance between user and storages
shinyUI(pageWithSidebar(
  headerPanel("Please insert your location"),
  sidebarPanel(
    textInput("city","City/County:","台北市"),
    textInput("dist","Dist./Township/Village:","大安區"),
    textInput("location","Location:","羅斯福路4段1號"),
    selectInput("storageSet", "Choose Storage Area:", choices = c("嘉義縣"="chiayi")),
    actionButton("act", "Go!")
  ),
  mainPanel(
    h3(textOutput("myTitle")),
    leafletOutput("myMap"),
    tableOutput("myDistance")
  )
))

