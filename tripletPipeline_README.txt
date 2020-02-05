Documentation for Triplet Pipeline as presented in
"Statistical Learning and Linear Model-Based Approaches to Integrate Transcriptome and Metabolome Data"
(Frontiers 2020)

Written by Allen H. Hubbard, PhD
and Heidi A. Van Every

v. 02042020
*Currently runs from two bash script wrappers*
Future updates will include combining this into a single command run with all inputs and eventually utilizing a docker container

#######################################

PURPOSE:
This series of scripts, currently run by a bash wrapper, allows for the parallel computation
of all possible combinations of metabolite triplets in a metabolomics dataset,
using the htCondor or miniCondor job engine, as described in Hubbard et al., 2020. 

First, an R script is written and submitted for every metabolite in the dataset (named by row number)
that tests for correlations between metabolite A and all other combinations of metabolite ratios B/C.
Cutoff is a difference of 1.4 or greater between the two conditions.
A perl script then calculates the p-gain of both individual triplets and merged triplets (those with one
or more overlapping components) with differing fates between conditions. Lists of these triplets meeting a p-gain
cutoff of >10 are output, ordered by significance and number of unique components.
Once the user has examined these lists, comparing with previous analyses such as a multi-step statistical learning
pipeline (Hubbard et al., 2018; Hubbard et al., 2019), and/or incorporating domain knowledge, separate scripts provided
can be used to visualize the linear models generated and run a permutation test to confirm significance or individual
triplets.

#######################################

--------- USAGE ------------

We currently recommend that this pipeline only be used on metabolite data. Although the approaches are general enough
to apply to different types of omic data, the interpretation of the output will be more complicated.

We also recommend preprocessing, including filtering, scaling, and normalizing in such a way that metabolite values
are comparable within and across samples. This is dependent  on the user’s preference, the type of data being used,
and the variability within the data. However, we caution that as Pearson correlations are used, normality assumptions
should be met, and results will also be affected by anomalies such as outliers. For an easy way to preprocess and visualize
the variability present in your data, we recommend using an accessible online tool: UC Davis’ Metaboanalyst 4 (Chong et al., 2018).
https://www.metaboanalyst.ca/faces/ModuleView.xhtml
The Statistical Analysis tool allows the export of metabolite table after normalization and scaling. We also recommend
filtering out low values or outliers, similar to preprocessing for differential expression analyses.
It is also important to remove special characters (spaces, quotes, commas) from the sample names as these will cause issues
with the pipeline. It is best to replace these with dashes (-), which can be done in Excel or with perl.

Numbers of replicates per condition do not have to be equal. This pipeline is currently written to compare two groups,
i.e. treatment and control


#######################################

--------- INPUT SPECIFICATIONS ------------

Metabolite data, in table format, with features in rows and observations in columns

File:
Computer readable tab-delimited .txt file (no spaces)
Rows = features(metabolites), columns = observations
--Row and column names must be unique identifiers

Header row:
--Format:
Label   Condition1_ID1  Condition1_ID2  ... Condition2_ID8  Condition2_ID9 ...

An shortened example of the input file is included as "EXAMPLEinput.txt"

#################################################################

--------- STEP 1 ------------

Dedicate a working directory, and move necessary scripts and metabolite input table to this directory
Edit "tripletConfig.sh"

VARIABLE DEFINITIONS:
workingDirec: pre-created working directory where scripts will be run and output files generated
inputFile: preprocessed, log-normalized and tab-separated file of metabolite values
pathToBash: location of bash files
condition1: comma-separated list of column headers that make up condition 1, as they appear in the input file
condition2: comma-separated list of column headers that make up condition 2, as they appear in the input file

Run script:
bash tripletConfig.sh

#################################################################

--------- STEP 2 ------------

Once all triplet correlations have finished running (this may take several minutes to an hour depending on how many
metabolites are in your dataset and how many CPUs you have available), edit "tripletConfig_p2.sh"
These variables will be the same as those in tripletConfig.sh
This step may take a while depending on how many triplets in your dataset meet the cutoff.

VARIABLE DEFINITIONS:
workingDirec: pre-created working directory where scripts will be run and output files generated
inputFile: preprocessed, log-normalized and tab-separated file of metabolite values

Run script:
bash bash tripletConfig_p2.sh

#################################################################

--------- STEP 3 ------------

Observe triplets in "pGainOver10" output files for merged and individual triplets. Select those of interest for visualization
of linear models in R and/or confirmation of significance using permutation test.

#################################################################

--------- STEP 4 ------------

Use "visualize_linear_models.R" to draw graphs of linear models, summarize model fit,  and calculate 
p-gains for individual triplets. Some editing of Rscript is required

Use "wrapper_for_pgain_test.sh" to run permutation test for individual triplets. You will need correlations and names
of the metabolites in the triplet. Enter these when prompted.

Command to run:
bash wrapper_for_pgain_test.sh
