library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(curl)
library(gmapsdistance)
library(ggmap)

mydf <- data.frame(address = NA, lat = NA, lon = NA)

shinyServer(function(input, output) {
  
  storageSetInput <- reactive({
    switch(input$storageSet, chiayi = chiayi_depot)
  })
  mySite <- eventReactive(input$act,
                          {geocode(sprintf("Distance between %s%s%s and nearest storage site",
                                           input$city,input$dist,input$location),
                                   output = 'all', messaging = TRUE, override_limit = TRUE )})
  
  points <- eventReactive(input$act, 
                          {storageSetInput}, 
                          ignoreNULL = FALSE)
  
  output$myTitle <- renderText({
    sprintf("Distance between %s%s%s and the nearest storage site",input$city,input$dist,input$location)
  })
  
  output$myMap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("OpenStreetMap",
                       options = providerTileOptions(noWrap = TRUE)) %>%
      addMarkers(data = points(),~lon, ~lat, 
                 popup = ~htmlEscape(sprintf("StorageName:%s \nWindow:%s \nContactNumber:%s", 
                                             storage_name, contact_window, contact_number))) %>% 
      addMarkers(data = mySite(),
                 lng=~results[[1]]$geometry$location$lng,
                 lat=~results[[1]]$geometry$location$lat,
                 popup = "Your Location")
    
  })
  
  output$myDistance <- renderTable({
    gmapsdistance(sprintf("%s+%s+%s",input$city,input$dist,input$location),
                  sprintf("%s+%s+%s+%s",points()[1,5], points()[1,6], points()[1,7], points()[1,8]))
  })
})
