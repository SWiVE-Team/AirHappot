require(data.table)
require(openxlsx)

hooksTable <- read.xlsx("chiayi_sharesTable.xlsx")
rownames(hooksTable) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
