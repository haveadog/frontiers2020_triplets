

#/Users/ahubbard/Desktop/bmc_submission_triplet_march_2019/carl_manuscript_september_2019/all_info_for_a_single_triplet_softcoding_dec_break.R /Users/ahubbard/Downloads/4v20_input3.txt /Users/ahubbard/Downloads/sample_triplet_info_to_parse.txt


#we'll need to know the model form (what's in control and what's in experimental)


#we'll also need to read in the metabolite file

#we'll also need to read in the table with the triplets themselves

args = commandArgs(trailingOnly=TRUE)


#table of metabolomics data
myInput = args[1]
triplets = args[2]

print(args)
print("is my args")
print(myInput)

print(triplets)

#tableOfImputedValues = read.table(file = "/Users/ahubbard/Downloads/4v20_input3.txt", header= TRUE,  stringsAsFactors = TRUE, row.names = 1)


#table of triplets
#infoOnAllTriplets = read.table(file = "/Users/ahubbard/Downloads/sample_triplet_info_to_parse.txt", sep="*",header=FALSE, stringsAsFactors = FALSE)



#tableOfImputedValues = read.table(file = "/Users/ahubbard/Downloads/4v20_input3.txt", header= TRUE,  stringsAsFactors = TRUE, row.names = 1)


#table of triplets
#infoOnAllTriplets = read.table(file = "/Users/ahubbard/Downloads/sample_triplet_info_to_parse.txt", sep="*",header=FALSE, stringsAsFactors = FALSE)





tableOfImputedValues = read.table(file = myInput, header= TRUE,  stringsAsFactors = TRUE, row.names = 1)


#triplets="/Users/ahubbard/Downloads/allTriplets_4v20_small.txt"

#table of triplets
infoOnAllTriplets = read.table(file = triplets, sep="\t",header=FALSE, stringsAsFactors = FALSE)





#the full pipeline is going to need to be structured:
#just take a set of metabolites
#just take membership of control and experimentals



#call the function!!
#for all of the smaller-ish set of triplets
#we'll want to read in the first and the second Triplet

#for each of the triplets calculate
#p-gain, r-quared and the score which is a function of both

#I'll make this an R function
#what will it need to take 


allTripletInfo <- function(arg1,arg2,arg3,arg4)
{

#here, we are going to work with the totalMetab file


compA = arg1
compB = arg2
compC = arg3
totalMetab = arg4

ratioName = paste0(compB , "/", compC)

fullNameFigure = paste(compA, " vs ",ratioName)



theSubset <- data.frame(A=numeric(ncol(totalMetab)), B=numeric(ncol(totalMetab)), C=numeric(ncol(totalMetab)), BDivC = numeric(ncol(totalMetab)), theIndicator = numeric(ncol(totalMetab)))








theSubset$A = (as.numeric(totalMetab[rownames(totalMetab) == compA,])) 

theSubset$BDivC = (as.numeric(totalMetab[rownames(totalMetab) == compB,]))  / (as.numeric(totalMetab[rownames(totalMetab) == compC,]))  
#theSubset$BDivC = (as.numeric(totalMetab[rownames(totalMetab) == "glycerol_3_phosphate",])) / (as.numeric(totalMetab[rownames(totalMetab) == "glycine",]))  

theSubset$B= (as.numeric(totalMetab[rownames(totalMetab) == compB,]))
theSubset$C = (as.numeric(totalMetab[rownames(totalMetab) == compC,]))


theSubset$A = log(theSubset$A)
theSubset$BDivC = log(theSubset$BDivC + .00000001)

#deal with any of the non-numeric or non-finite values
theSubset$A[is.finite(theSubset$A) == FALSE] <- 0
theSubset$B[is.finite(theSubset$B) == FALSE] <- 0
theSubset$C[is.finite(theSubset$C) == FALSE] <- 0


theSubset$BDivC[is.finite(theSubset$BDivC) == FALSE] <- 0


summary(lm(A ~ BDivC*theIndicator, data=theSubset))$adj.r.squared

theSubset$theIndicator = rownames(theSubset)

theSubset$theIndicator = gsub("(.*)_.*", "\\1", theSubset$theIndicator)


     

         theSubset$theIndicator = rownames(theSubset)




         # theSubset$theIndicator = substr(theSubset$theIndicator,1,nchar(as.character(theSubset$theIndicator))-5)

         theSubset$theIndicator = colnames(totalMetab)
         theSubset$theIndicator = gsub("(.*)_.*", "\\1", theSubset$theIndicator)



#this will, ultimately, need to be soft-coded and taken as input 
#as part of the platform
#theSubset$theIndicator = c(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1)
theSubset$theIndicator <- factor(theSubset$theIndicator)


#nameForRatio = 

#plot(theSubset$BDivC,theSubset$A, pch=21, bg=c("red","green")[unclass(theSubset$theIndicator)], main=fullNameFigure, xlab=ratioName, ylab=compA)


#theSubsetZeroes = theSubset[which(theSubset$theIndicator=="0"),]
#abline(lsfit(theSubsetZeroes$BDivC, theSubsetZeroes$A)$coefficients, col="red")

#theSubsetOnes = theSubset[which(theSubset$theIndicator=="1"),]
#abline(lsfit(theSubsetOnes$BDivC, theSubsetOnes$A)$coefficients, col="green")



intialPvalueTable = summary(lm(BDivC ~ theIndicator*A, data=theSubset))$coefficients

intialPvalue = intialPvalueTable[nrow(intialPvalueTable),ncol(intialPvalueTable)]

rSquared = summary(lm(BDivC ~ theIndicator*A, data=theSubset))$adj.r.squared


#pValueForPGain = intialPvalue[nrow(intialPvalue),ncol(intialPvalue)]


#p-gain will essentially be just one model compared to another

#table of data


#calculate the p-gain for model using just B

theSubset$B= theSubset$B + .0000001

TableOfDataB= summary(lm(B~ A*theIndicator, data=theSubset))$coefficients


pValB= TableOfDataB[nrow(TableOfDataB),ncol(TableOfDataB)]

#calculate the p-gain for model using just C
TableOfDataC = summary(lm(C ~ A*theIndicator, data=theSubset))$coefficients

pValC = TableOfDataC[nrow(TableOfDataC),ncol(TableOfDataC)]


pGainB = pValB/ intialPvalue
pGainC = pValC / intialPvalue



rankingScore = min(pGainB, pGainC) * rSquared 

#we'll also do the plot (and return the vector with the)

print(compA)
return(c(compA, compB, compC, rankingScore))

}








#table to hold the p-gain information
pValsAndGainNoMerged = data.frame("A" = 0, "B" = 0, "C" = 0, "PGainTimesRSquared" = 0)


#for each pair of triplets
#which could be a a circuit
#we are going to build the linear models
#pdf("smallTripletsFromKmeansForSchmidtExtrasMoreII.pdf")

for (i in 1:nrow(infoOnAllTriplets))
{
	
	#split in order to get triplet 1 and triplet 2
	
	
	
	A1 = as.character(infoOnAllTriplets[i,][2])
	#we are going to need to get A, B, and C from each of the two triplets
	
	
	
	#now, we're going to split at the "/" in the fields that come 
	#after the ,
	
	
	ratioComponent1 = infoOnAllTriplets[i,][3]
	vecOfRatio1 = unlist(strsplit(as.character(ratioComponent1), "/"))
	
	
	#get B and C for the first ratio
	B1 = vecOfRatio1[1]
	C1 = vecOfRatio1[2]
	if(A1 != B1 && A1 != C1 && B1 != C1 )
	{
	
	
	#get all of the p-gain info for triplet 1
	 theVecTrip1 = allTripletInfo(A1, B1,C1, tableOfImputedValues)
	
	#print(theVecTrip1)
	
	
	#store in the table
	#pValsAndGain = rbind(pValsAndGain, theVecTrip1)
	
	#now, we are going to repeat everything
		#store in the table
	 pValsAndGainNoMerged = rbind(pValsAndGainNoMerged, theVecTrip1)
	
 	}
	#print(A1)
	#print(A2)
}

pValsAndGainNoMerged = pValsAndGainNoMerged[-1,]
pValsAndGainNoMerged = pValsAndGainNoMerged[order(-as.numeric(pValsAndGainNoMerged$PGainTimesRSquared)),]


print(pValsAndGainNoMerged)
print("is the pValsAndGain")
write.table(pValsAndGainNoMerged, file = "pValsAndGain_SingleTriplets.txt", sep = "\t", row.names = F)

pGainOver10.unmerged <- pValsAndGainNoMerged[as.numeric(pValsAndGainNoMerged$PGainTimesRSquared) >= 10, ]

#uniqueTriplets <- pGainOver10[,c(1:3,5:7)]

#uniqueTriplets$count <- apply(uniqueTriplets, 1, function(x)length(unique(x)))

#pGainOver10$count <- apply(pGainOver10, 1, function(x)length(unique(x)))

write.table(pGainOver10.unmerged, file = "pGainOver10_singleTriplets.txt", sep = "\t", row.names = F)
#write.table(uniqueTriplets, file = "uniqueTriplets.txt", sep = "\t", row.names = F)




