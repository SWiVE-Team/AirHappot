require(rMaps)
require(rCharts)
#library(htmltools)
#library(magrittr)

map <- Leaflet$new()
map$setView(c(23.3744770, 120.5022379), 16)
map$tileLayer(provider = 'OpenStreetMap')
map

mywaypoints <- list(c(23.3744770, 120.5022379), c(23.4222641, 120.5264703))
map$addAssets(
  css = "http://www.liedman.net/leaflet-routing-machine/dist/leaflet-routing-machine.css",
  jshead = "http://www.liedman.net/leaflet-routing-machine/dist/leaflet-routing-machine.min.js"  
  )

routingTemplate <- "
<script>
var mywaypoints = %s
L.Routing.control({
waypoints: [
L.latLng.apply(null, mywaypoints[0]),
L.latLng.apply(null, mywaypoints[1])
]
}).addTo(map);
</script>
"

map$setTemplate(afterScript = sprintf(routingTemplate, RJSONIO::toJSON(mywaypoints)))
map$set(width = 1200, height = 800)
map
               