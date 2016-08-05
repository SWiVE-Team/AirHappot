require(openxlsx)
require(data.table)
require(RColorBrewer)
require(scales)
require(leafletR)
require(leaflet)

groupList <- levels(factor(chiayi_depot$township))
pal <- brewer.pal(6, "Dark2")

#no use for now 
#data.json <- geojson_json(chiayi_depot, lat = 'lat', lon = 'lon') 

dest.path <- "./code_needs"

siteMap.geocode <- toGeoJSON(data=chiayi_depot, dest = dest.path, lat.lon=c("lat", "lon"))
siteMap.style <- styleCat(prop="township", val=groupList, style.val= pal)
siteMap <- leaflet(data=siteMap.geocode, title = "Chiayi_storage_site", style=siteMap.style, 
                   base.map = c("tls", "water", "toner", "tonerbg", "tonerlite", "positron", "osm"), 
                   popup="Chiayi_storage_site")

browseURL(siteMap)




