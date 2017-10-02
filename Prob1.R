rm(list = ls(all = TRUE))
#Read Excel worksheets into R and standardize formatting
#Note: I concatenated column names in Excel (e.g., "Tab No" -> "Tab.No") 
#to keep R from splitting columns.
#findPossLocs.R
library(XLConnect)
source("findPossLocs.R")
gaps <- readWorksheetFromFile('Tab_Villages_Mapping25July2015.xlsx', sheet = 1)
info <- readWorksheetFromFile('Tab_Villages_Mapping25July2015.xlsx', sheet = 2)

#Convert dates in tablet use info to same Year-Month-Day format as survey entry forms
#Convert dates in "gaps" to Date class (no need for POSIXt, and I need to pick one)
# for comparisons

info[,"Survey.Start.Date"] <- as.Date(info[, "Survey.Start.Date"], "%d-%b-%Y")
info[,"Survey.End.Date"] <- as.Date(info[, "Survey.End.Date"], "%d-%b-%Y")
gaps$Survey.Date <- as.Date(gaps$Survey.Date)
findPossLocs(gaps[1,])
#determine and insert locations
filled <- apply(gaps,1,findPossLocs)
finalAnswer <- data.frame(matrix(filled, nrow = nrow(gaps), byrow = TRUE))
colnames(finalAnswer) <- c("Response No.", "Tab No.", "Survey Date", 
                           "AC Name", "Mandal Name", "Village Name")
write.csv(finalAnswer, file = "Problem1Solution.csv")
