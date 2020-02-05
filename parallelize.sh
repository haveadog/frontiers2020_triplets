#!/bin/bash
#have an R script basically run this iteratively

# input variables from command
theNum=$1
vecName=${theNum}
toRunExpString=$2  
controlVecString=$3
myFile=$4
myPathToEverything=$5
bashLocation=$6

#echo ${myTestReceive}
#echo "is myTestReceive"

#take in compound A as a command

echo $controlVecString
echo " is controlVecString"


#split everything at the comma and put into an array from
#which we will create a string that de-references the quotations 

IFS=', ' read -r -a toRunExpStringSplit <<< "$toRunExpString"

allExpLibsToPrint=""

for val in ${toRunExpStringSplit[@]}; do

   #echo $val

   #echo " is an exp Lib"

   allExpLibsToPrint="${allExpLibsToPrint} \"${val}\","

done



#echo $allExpLibsToPrint
#echo " is after we've put everything together"


#do the same for the control libraries

IFS=', ' read -r -a toRunControlStringSplit <<< "$controlVecString"



ARRAYExpLibs=()

allControlLibsToPrint=""

for val in ${toRunControlStringSplit[@]}; do

   #echo $val

   allControlLibsToPrint="${allControlLibsToPrint} \"${val}\","

   ARRAYExpLibs+=(\"${val}\")

done


allControlLibsToPrintII="${allControlLibsToPrint::-1}"

allExpLibsToPrintII="${allExpLibsToPrint::-1}"


loopcode="#get vec A control

   tableOfImputedValues = read.csv(file = \"${myFile}\",sep = \"\t\", row.names = 1, header= TRUE)

   totalMetab = tableOfImputedValues

 
 #colnames(subsetOrganOfInterest) = colnames(totalMetab)

 toModelII = totalMetab

 ###Read in the metabolite data


 ###Go through the list of the liver libraries

 #have a set of libraries for control and experimental

 subsetLibsOfInterest <- c($allExpLibsToPrintII)

 subsetLibsOfInterest2 <- c($allControlLibsToPrintII)
 

 theSorted = rownames(toModelII)

 

  theCompleteTable <- data.frame(\"A\" = character(1), \"BDividedByC\" = numeric(1), \"CorrelationBWithCHeat\" = numeric(1), \"CorAWithBHeat\" = numeric(1), \"CorAWithCHeat\" = numeric(1), \"CorBWithCControl\" = numeric(1), \"CorAWithBControl\" = numeric(1),\"CorAWithCControl\" = numeric(1), \"Cor_A_BdivC_Heat\" = numeric(1), \"Cor_A_BdivC_Control\" = numeric(1), stringsAsFactors=FALSE)

 

    

   compoundA = rownames(toModelII)[${theNum}]   

   vecAControl = toModelII[rownames(toModelII) == compoundA,colnames(toModelII) %in% subsetLibsOfInterest]

   

   

   #get vec A heat stress

   vecAHS = toModelII[rownames(toModelII) == compoundA,colnames(toModelII) %in% subsetLibsOfInterest2]

   

   

   

   toPrint=paste(${vecName},\"image_info.pdf\", sep = \"_\")

   pdf(toPrint)

   

   #choose B

   for(j in 1:length(theSorted))

   {   

     

    

     compoundB = theSorted[j]

     

    

     

     #get vec B control

     

     vecBControl = toModelII[rownames(toModelII) == compoundB, colnames(toModelII) %in% subsetLibsOfInterest]

     

     #get vec B heat stress

     vecBHS = toModelII[rownames(toModelII) == compoundB, colnames(toModelII) %in% subsetLibsOfInterest2]

     

     #choose C

     for(k in 1:length(theSorted))

     {

       

       

       compoundC = theSorted[k]

         

       #get vec C control

       vecCControl = toModelII[rownames(toModelII) == compoundC,colnames(toModelII) %in% subsetLibsOfInterest]

       

       #get vec C heat stress

       vecCHS = toModelII[rownames(toModelII) == compoundC, colnames(toModelII) %in% subsetLibsOfInterest2]

         

       #cor exp    

       theExpCor = cor((as.numeric(vecAHS) + .01), ((as.numeric(vecBHS) + .01) / (as.numeric(vecCHS) + .01)))

       theControlCor = cor((as.numeric(vecAControl) + .01), ((as.numeric(vecBControl) + .01) / (as.numeric(vecCControl) + .01)))

       

       theExpCor[is.na(theExpCor)] = 0

       theControlCor[is.na(theControlCor)] = 0

       

       

      

       

       if(abs(theExpCor - theControlCor) > 1.4)

       {

         

         

         ###comment this out, ju 23rd - note well    

         rowToWrite = nrow(theCompleteTable) + 1

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"A\")] = compoundA

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"BDividedByC\")] = paste(compoundB,compoundC, sep = \"/\")

         

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"CorrelationBWithCHeat\")] = cor((as.numeric(vecBHS) + .01), (as.numeric(vecCHS) + .01))

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"CorAWithBHeat\")] = cor((as.numeric(vecAHS) + .01), (as.numeric(vecBHS) + .01))

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"CorAWithCHeat\")] = cor((as.numeric(vecAHS) + .01), (as.numeric(vecCHS) + .01))

         

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"CorBWithCControl\")] = cor((as.numeric(vecBControl) + .01), (as.numeric(vecCControl) + .01))

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"CorAWithBControl\")] = cor((as.numeric(vecAControl) + .01), (as.numeric(vecBControl) + .01))

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"CorAWithCControl\")] = cor((as.numeric(vecAControl) + .01), (as.numeric(vecCControl) + .01))

         

         

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"Cor_A_BdivC_Heat\")] = theExpCor

         theCompleteTable[rowToWrite, which(colnames(theCompleteTable) == \"Cor_A_BdivC_Control\")] = theControlCor

         

         

         

         theSubset <- data.frame(A=numeric(ncol(totalMetab)), B=numeric(ncol(totalMetab)), C=numeric(ncol(totalMetab)), BDivC = numeric(ncol(totalMetab)), theIndicator = numeric(ncol(totalMetab)))

 

         rownames(theSubset) = colnames(toModelII)



         theSubset\$theIndicator = rownames(theSubset)



	





         # theSubset\$theIndicator = substr(theSubset\$theIndicator,1,nchar(as.character(theSubset\$theIndicator))-5)



	 theSubset\$theIndicator = gsub(\"(.*)_.*\", \"\\\\1\", theSubset\$theIndicator) 





	     #now, replace everything wth the imputate values

         cond1 =	unique(gsub(\"(.*)_.*\", \"\\\\1\", theSubset\$theIndicator))[1]

         cond2 = unique(gsub(\"(.*)_.*\", \"\\\\1\", theSubset\$theIndicator))[2]



         theSubset\$A = (as.numeric(totalMetab[rownames(totalMetab) == compoundA,]))

         #theSubset\$A = log(theSubset\$A)

         #theSubset\$B = log(as.numeric(totalMetab[rownames(totalMetab) == compoundB,]))  

         #theSubset\$C = log(as.numeric(totalMetab[rownames(totalMetab) == compoundC,]))

	 theSubset\$A = theSubset\$A

         theSubset\$B = as.numeric(totalMetab[rownames(totalMetab) == compoundB,])

         theSubset\$C = as.numeric(totalMetab[rownames(totalMetab) == compoundC,])

 

        HStoImputeFrom <- subset(theSubset, theIndicator == cond1)

        ImputedAHS = mean(HStoImputeFrom\$A[!is.infinite(HStoImputeFrom\$A)])

        ImputedBHS = mean(HStoImputeFrom\$B[!is.infinite(HStoImputeFrom\$B)])

        ImputedCHS = mean(HStoImputeFrom\$C[!is.infinite(HStoImputeFrom\$C)])





        CtltoImputeFrom <- subset(theSubset, theIndicator == cond2)

        ImputedACtl = mean(CtltoImputeFrom\$A[!is.infinite(CtltoImputeFrom\$A)])

        ImputedBCtl = mean(CtltoImputeFrom\$B[!is.infinite(CtltoImputeFrom\$B)])

        ImputedCCtl = mean(CtltoImputeFrom\$C[!is.infinite(CtltoImputeFrom\$C)])



        #now, replace everything wth the imputate values



        theSubset\$A[is.finite(theSubset\$A) == FALSE & theSubset\$theIndicator == cond1] =  ImputedAHS

        theSubset\$B[is.finite(theSubset\$B) == FALSE & theSubset\$theIndicator == cond1] =  ImputedBHS

        theSubset\$C[is.finite(theSubset\$C) == FALSE & theSubset\$theIndicator == cond1] =  ImputedCHS





        theSubset\$A[is.finite(theSubset\$A) == FALSE & theSubset\$theIndicator == cond2] =  ImputedACtl

        theSubset\$B[is.finite(theSubset\$B) == FALSE & theSubset\$theIndicator == cond2] =  ImputedBCtl

        theSubset\$C[is.finite(theSubset\$C) == FALSE & theSubset\$theIndicator == cond2] =  ImputedCCtl

        

 

        

 

         theSubset\$BDivC = theSubset\$B / theSubset\$C

         theSubset\$BDivC = as.numeric(theSubset\$BDivC)

         

         

         theSubset\$A[is.na(theSubset\$A)] = 0

         theSubset\$B[is.na(theSubset\$B)] = 0

         theSubset\$C[is.na(theSubset\$C)] = 0

         theSubset\$BDivC[is.na(theSubset\$BDivC)] = 0

         

         theSubset\$theIndicator <- factor(theSubset\$theIndicator)

        

         theRatioName = paste(compoundB,\"/\",compoundC)

         #png(toPrint)

         plot(as.numeric(theSubset\$BDivC),as.numeric(theSubset\$A), pch=21, bg=c(\"green\",\"red\")[unclass(theSubset\$theIndicator)], main=\"A vs B/C\", xlab=theRatioName, ylab=compoundA)

 

         theSubsetZeroes = theSubset[which(theSubset\$theIndicator==cond1),]

         abline(lsfit(theSubsetZeroes\$BDivC, theSubsetZeroes\$A)$coefficients, col=\"green\")

 

         theSubsetOnes = theSubset[which(theSubset\$theIndicator==cond2),]

         abline(lsfit(theSubsetOnes\$BDivC, theSubsetOnes\$A)\$coefficients, col=\"red\")

 

         legend( x= \"right\", y=0.1, 

         legend=c(\"Drought\",\"Control\"), 

         col=c(\"red\", \"green\"),   

         lty=1:2, cex=0.8)

  

         legend( x= \"topleft\", y=0.1, legend=c(\"DS\",\"Ctl\"), col=c(\"red\", \"green\"), lty=1:2, cex=0.8)

 

         

         print(theSubset)

         print(summary(lm(A ~ BDivC*theIndicator, data=theSubset)))

 

 

         

         

       }

       

     }

     

   }

   

   

   dev.off()

   #we'll write the table now

   write.table(theCompleteTable, file = \"${vecName}_table.txt\")

"





echo "${loopcode}" >${vecName}R.R



#here's the command to vanilla R run the code

echo "R --vanilla < ${vecName}R.R" > ${vecName}_vanillaRscript.sh



#create the r script - have it submit itself to the job scheduler



#print to a file







#run the shell script that will do the vanilla R submit



make_job ()

{





echo "

Log        = ${vecName}.log

Output     =  ${vecName}.out

Error	   = ${vecName}.error



executable                = $bashLocation

arguments                = ${myPathToEverything}/${vecName}_vanillaRscript.sh 



queue" > ${vecName}_condor.sh



condor_submit ${vecName}_condor.sh



#get the basename here





}

make_job



#echo "hello"















