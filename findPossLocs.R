#Preconditions: survey form x's location empty, list of tablets
#and their locations over date ranges provided

#Postcondition: Uniquely determinable survey form locations filled in, others
#labelled "Intermediate"

#Inputs: The survey date and tablet number of a row in the "gaps" table

#Output: the AC, Mandal, and Village for the given row as far as can be determined.
#         If not determined uniquely, return "Intermediate"
findPossLocs <- function(x){
  #Possible survey tablets and times are those where survey date 
  #is in survey date range and tablet numbers match data for blank entries.
  
  posEntries <- info[info$Tab.No == as.numeric(x[2])
                     & info$Survey.Start.Date <= x[[3]]
                     & info$Survey.End.Date >= x[[3]], ]

  # Determines up to ambiguity which surveys come from which village. Does not assume 
  # all village names across different Mandals are unique
  #Some values return NA because no match was found for a
  #possible survey location(see entry 2, 22). Label those
  #"Intermediate" as well.
  if(length(unique(posEntries[,"AC.Name"])) > 1){
    x[["AC.Name"]] = "Intermediate"
    x[["Mandal.Name"]] = "Intermediate"
    x[["Village.Name"]] = "Intermediate"
    return(x)
  }
  x[["AC.Name"]] = posEntries[1, "AC.Name"]
  if(length(unique(posEntries[,"Mandal.Name"])) > 1){
    x[["Mandal.Name"]] = "Intermediate"
    x[["Village.Name"]] = "Intermediate"
    return(x)
  }
  x[["Mandal.Name"]] = posEntries[1, "Mandal.Name"]
  if(length(unique(posEntries[,"Village.Name"])) > 1){
    x[["Village.Name"]] <- "Intermediate"
    return(x)
  }
  x[["Village.Name"]] = posEntries[1, "Village.Name"]
  #Make any remaining "NA" values return as "Intermediate".
  x[which(is.na(x))] <- "Intermediate"
  return(x)
}