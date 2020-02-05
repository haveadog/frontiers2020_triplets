workingDirec="/home/user/tripletWD"
inputFile="EXAMPLEinput.txt"

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
mv ./*table.txt ./output_files

# STEP 3: merge triplets
perl MERGE.pl allTriplets.tsv T1 1.8 | sed '/!!!/d' | sed '/ /d' > mergedTriplets.tsv

#STEP 4: calculate pGain for merged triplets
Rscript --vanilla calculatePgain_mergedTriplets.R $inputFile mergedTriplets.tsv

#STEP 5: calculate pGain for individual triplets
Rscript --vanilla calculatePgain_unmergedTriplets.R $inputFile allTriplets.tsv
