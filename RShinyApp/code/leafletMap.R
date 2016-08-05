###create a map with chiayi depot points
require(leaflet)
require(magrittr)
###============example===================
### Method 1
m <- leaflet() %>% 
  addTiles() %>% # add default OpenStreetMap map titles
  addMarkers(lng = 174.768, lat = -36.852, popup = "The birthplace of R")
m # print the map

### Method 2
m <- leaflet()
m <- addTiles(m)
m <- addMarkers(m, lng = 174.768, lat = -36.852, popup = "The birthplace of R")
m
###======================================
require(htmltools)
#require(geojsonio)
#require(jsonlite)

leaflet(chiayi_depot) %>% addTiles() %>% 
  addMarkers(~lon, ~lat, popup = ~htmlEscape(address))

leaflet(chiayi_depot) %>% addTiles() %>% 
  addMarkers(~lon, ~lat, popup = ~htmlEscape(sprintf("StorageName:%s  \n         
                                                     Window:%s \n
                                                     ContactNumber:%s", storage_name, contact_window, contact_number)))






