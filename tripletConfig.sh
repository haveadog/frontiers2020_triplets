workingDirec="/home/user/tripletWD"
inputFile="EXAMPLEinput.txt"
pathToBash="/bin/bash"
condition1="D4_1650,D4_1651,D4_1776,D4_1653,D4_1654,D4_1655,D4_1656,D4_1657,D4_1671,D4_1672,D4_1673"
condition2="D20_1742,D20_1743,D20_1733,D20_1734,D20_1735,D20_1736,D20_1744,D20_1745,D20_1746,D20_1747,D20_1748,D20_1749"

# STEP 1: get all-all correlations of triplets
Rscript tripletPipeline.R $workingDirec/$inputFile $condition1 $condition2 $workingDirec $pathToBash

# WILL NEED TO SLEEP UNTIL FINISHED
exit


# STEP 2: concatenate and format output
mkdir ./output_files
mv ./*.log ./output_files
mv ./*.error ./output_files
mv ./*condor.sh ./output_files
mv ./*vanilla* ./output_files
mv ./*R.R ./output_files
mv ./*.out ./output_files
mv ./*.pdf ./output_files

cat *table.txt | sed '/Correlation/d' | sed '/0 0 0 0 0 0/d' | perl -ple 's/ /\t/g' > allTriplets.tsv
mv ./*.table.txt ./output_files

# STEP 3: merge triplets
perl MERGE.pl allTriplets.tsv T1 1.8 | sed '/!!!/d' | sed '/ /d' > mergedTriplets.tsv

#STEP 4: calculate pGain for merged triplets
Rscript --vanilla calculatePgain_mergedTriplets.R $inputFile mergedTriplets.txt

#STEP 5: calculate pGain for individual triplets
Rscript --vanilla calculatePgain_unmergedTriplets.R $inputFile allTriplets.tsv
