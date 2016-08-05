library(shiny)
library(leaflet)
#library(gmapsdistance)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
  p(class = "text-muted",
    "All Chiayi Storage Site:"),
  leafletOutput("mymap",height = 650),
  actionButton("move", "Next Storage Site!")
)

server <- function(input, output, session) {
  
  points <- eventReactive(input$move, 
                          {chiayi_depot}, 
                          ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("OpenStreetMap",
                       options = providerTileOptions(noWrap = TRUE)) %>%
      addMarkers(data = points(),~lon, ~lat, 
                 popup = ~htmlEscape(sprintf(paste("StorageName : %s", "Window : %s", "ContactNumber : %s", 
                                                   sep = "\n"), 
                                             storage_name, contact_window, contact_number)))
  })
}

shinyApp(ui, server)
