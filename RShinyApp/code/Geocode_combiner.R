require(data.table)
require(openxlsx)

### on Mac, input data 
options(digits = 15)
myDepot <- read.table("../data/chiayi_storage_geo.txt", header = TRUE, sep = ",")
chiayi_depot$lat <- myDepot$Response_X
chiayi_depot$lon <- myDepot$Response_Y

### on Windows, input data by clipboard
path1 <- "..\\data\\chiayi_storage_geo.txt"
path2 <- "..\\data\\\\嘉義縣物資所105.1.28.xlsx"
options(digits = 15)
myDepot <- read.table(file = "clipboard", sep = ",", header = TRUE)
chiayi_depot <- read.xlsx(path2)

chiayi_depot <- data.table(chiayi_depot, address = myDepot$Address, 
                   lat = myDepot$Response_X, lon = myDepot$Response_Y)

colnames(chiayi_depot) <- c("ref", "storage_name", "window", "contact_number", 
                            "county/cuty", "township", "village", "location", 
                            "address", "lat", "lon")