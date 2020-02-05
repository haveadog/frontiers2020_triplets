#workingDirec="/home/hve/triplets_4v20/DECEMBER_TROUBLESHOOTING/pipelineTest/saraTest"
#inputFile="sara_metabs_input2.txt"
#pathToBash="/bin/bash"
#condition1="C_1330,C_1331,C_1332,C_1333,C_1334,C_1335,C_1336,C_1337"
#condition2="HS_1321,HS_1322,HS_1323,HS_1324,HS_1325,HS_1326,HS_1327,HS_1328"


#read in the inputs from the user
read -rp "Enter the correlation between B and C for the first triplet: " kor_M1_M2
read -rp "Enter the correlation between B and the ratio for the first triplet: " kor_M1_ratio
read -rp "Enter the correlation between C and the ratio for the first triplet: " kor_M2_ratio
 

####now, get the information for the second triplet####
#read in the inputs from the user
read -rp "Enter the correlation between B and C for the second triplet: " kor_M1_M2_two
read -rp "Enter the correlation between B and the ratio for the second triplet: " kor_M1_ratio_two
read -rp "Enter the correlation between C and the ratio for the second triplet: " kor_M2_ratio_two
read -rp "Level of significance to which you would like for values of the null distribution of the p-gain (.05 creates 95 percent confidence interval for p-gain): " alpha
read -rp "Please enter the name of the 'A' metabolite: " AMetab
read -rp "Please enter the name of the 'B' metabolite: " BMetab
read -rp "Please enter the name of the 'C' metabolite: " CMetab





echo "$kor_M1_M2 is kor_M1_M2"

echo "Rscript copula_function_to_reference.R $kor_M1_M2 $kor_M1_ratio $kor_M2_ratio $kor_M1_M2_two $kor_M1_ratio_two $kor_M2_ratio_two $alpha $AMetab $BMetab $CMetab"
echo " is the command to run the R script"


# STEP 1: place all the information in order to determine the p-gain
Rscript ./copula_function_to_reference.R $kor_M1_M2 $kor_M1_ratio $kor_M2_ratio $kor_M1_M2_two $kor_M1_ratio_two $kor_M2_ratio_two $alpha $AMetab $BMetab $CMetab

