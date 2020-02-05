 #run the commands
 

#will need to soft-code this, as well
#tableOfImputedValues = read.table(file = "/home/ahubbard/triplet_search_setaria_and_chicken_dissertation_data/searching_for_triplets_HS/imputed_values_at_time_HS.txt")

args = commandArgs(trailingOnly=TRUE) 


myInput = args[1]
controlSet = args[2]
expSet = args[3]
#myTestReceive=args[3]
myPathToEverything=args[4]
bashLocation=args[5]
tableOfImputedValues = read.table(file = myInput)


 
controlLibs = unlist(strsplit(controlSet, ","))
expLibs = unlist(strsplit(expSet, ","))


print(controlLibs)
print(" is the control libs")

controlVecToString = vector()
 for(i in 1:length(controlLibs))
 {

  #we need to make the string of all the libraries
  controlVecToString = c(controlVecToString, paste0("\"",paste0(controlLibs[i], "\"")))
  print(controlLibs[i])
}

expVecToString = vector()
 for(i in 1:length(expLibs))
 {

  #we need to make the string of all the libraries
  expVecToString = c(expVecToString, paste0("\"",paste0(expLibs[i], "\"")))
  print(expLibs[i])
}


#then, we'll put them into a string!!!#
toRunExpString = paste(expVecToString, collapse = ",")
controlVecString = paste(controlVecToString , collapse = ",")

print(toRunExpString)
print(" before passing")


print(controlVecString)
print(" before passing")

#choose A
 
theSorted = rownames(tableOfImputedValues) 
 #we'll run the system command 
 for(i in 1:length(theSorted))
 {
   print(i)
   compoundA = theSorted[i]
   
   #provide the number !
   
   #each run of the R code will now receive the list of control and experimental groups


   print(toRunExpString)
   print(" before passing")


   print(controlVecString)
   print(" before passing")   
   theString = paste("bash", paste0(myPathToEverything,"/parallelize.sh"), i, toRunExpString,  controlVecString, myInput, myPathToEverything, bashLocation)
   print(theString)

   system(theString)
 }


 
