require(shinydashboard)
require(leaflet)

header <- dashboardHeader(title = "Storage Site Map")

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("myMap", height = 500)),
           box(width = NULL,
               uiOutput("distInfo"))
           ),
    column(width = 3,
           box(width = NULL, status = "warning",
               p(
                 class = "text-muted",
                 "Please Insert Your Location:"
               ),
               sidebarLayout(sidebarPanel(textInput("city","City/County:","台北市"),
                                          textInput("dist","Dist./Township/Village:","大安區"),
                                          textInput("location","Location:","羅斯福路4段1號"),
                                          selectInput("storageSet", "Choose Storage Area:", choices = c("嘉義縣"= chiayi))
                                          )
                             ),
               actionButton("act", "Go!")
               )
           )
    )
  )

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)







