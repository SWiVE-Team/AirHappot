require(openxlsx)
require(data.table)
require(ggmap)

### input Chiayi_storage.xlsx, and get the full address
path = "../data/嘉義縣物資所105.1.28.xlsx"
chiayi_depot <- read.xlsx(path)
address <- mapply(paste0, chiayi_depot$所在縣市, chiayi_depot$存放點鄉鎮, chiayi_depot$存放點村里, chiayi_depot$存放點地址)
chiayi_depot <- data.table(chiayi_depot, address = address)
colnames(chiayi_depot) <- c("ref", "storage_name", "contact_window", "contact_number", "city/county", "township", "village", "location", "address")
chiayi_depot <- data.table(chiayi_depot, lat = NA, lon = NA)

### get lat/lon of each address
getGeoDetails <- function(address)
{
  #use the geocode function to query google servers
  geo_reply <- geocode(address, output = "all", messaging = TRUE, override_limit = TRUE)
  
  #extract the bits that we need from the returned list
  answer <- data.table(lat = NA, long = NA, accuracy = NA, formatted_address = NA, address_type = NA, status = NA)
  answer$status <- geo_reply$status
  
  #if we are over the query limit - want to pause for an hour
  while(geo_reply$status == "OVER_QUERY_LIMIT"){
    print("OVER_QUERY_LIMIT - Pausing for 1 hour:")
    time <- Sys.time()
    print(as.character(time))
    Sys.sleep(60*60)
    geo_reply <- geocode(address, output = "all", messaging = TRUE, override_limit = TRUE)
    answer$status <- geo_reply$status
  }
  
  # return NA's if we didn't get a match
  if(geo_reply$status != "OK")
  {
    return(answer)
  }
  
  #else, extract what we need from the Google server reply into a dataframe:
  answer$lat <- geo_reply$results[[1]]$geometry$location$lat
  answer$long <- geo_reply$results[[1]]$geometry$location$lng   
  if (length(geo_reply$results[[1]]$types) > 0){
    answer$accuracy <- geo_reply$results[[1]]$types[[1]]
  }
  answer$address_type <- paste(geo_reply$results[[1]]$types, collapse=',')
  answer$formatted_address <- geo_reply$results[[1]]$formatted_address
  
  return(answer)
}

#initialise a data.table to hold the results
geocoded <- data.table()
# find out where to start in the address list (if the script was interrupted before):
startindex <- 1
#if a temp file exists - load it up and count the rows!
tempfilename <- paste0("chiayi_storage", '_temp_geocoded.rds')
if (file.exists(tempfilename)){
  print("Found temp file - resuming from index:")
  geocoded <- readRDS(tempfilename)
  startindex <- nrow(geocoded)
  print(startindex)
}

# Start the geocoding process - address by address. geocode() function takes care of query speed limit.
for (i in seq(startindex, length(address))){
  print(paste("Working on index", i, "of", length(address)))
  #query the google geocoder - this will pause here if we are over the limit.
  result = getGeoDetails(address[i]) 
  print(result$status)     
  result$index <- i
  #append the answer to the results file.
  geocoded <- rbind(geocoded, result)
  #save temporary results as we are going along
  saveRDS(geocoded, tempfilename)
}
#now we add the latitude and longitude to the main data
chiayi_depot$lat <- geocoded$lat
chiayi_depot$long <- geocoded$long
chiayi_depot$accuracy <- geocoded$accuracy

#finally write it all to the output files
saveRDS(chiayi_depot, paste0("./code_needs/", "chiayi_storage","_geocoded.rds"))
write.table(chiayi_depot, 
            file = paste0("./code_needs/", "chiayi_storage", "_geocoded.csv"), 
            sep = ",", 
            row.names = FALSE)




