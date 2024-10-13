#!/bin/bash

# This script is used to generate Job scripts for Executing from data dirs

############################ Configuration ###############################
DataDir='/home/storage2/users/wangyinjie/Ntuple-Processor-main-copy/ntuple/ntuple_data_2018_mine/' # Ntuple source dir
TreeDir='mkcands/X_data' # Tree Directory in .root files used, please check it in root
JobScriptDir='/home/storage2/users/wangyinjie/Ntuple-Processor-main-copy/run2018' # Directory to store Job Scripts, force to remove and re-create it
OutPutDir='/home/storage2/users/wangyinjie/Ntuple-Processor-main-copy/Data/Data3' # Output directory, force to remove and re-create it
OutPutDiscription='2018 Data run' # Discription of job, saved as .md file in OutPutDir
# Attention! To finish Configuration, the output file name format should be checked below
########################################################################## 

rm -rf $JobScriptDir
mkdir -p $JobScriptDir
cp Execute.C $JobScriptDir
rm -rf $OutPutDir
mkdir -p $OutPutDir
echo $OutPutDiscription > $OutPutDir/README.md
find $DataDir -type d -links 2 > temp.out
n=0
cat temp.out | while read rows
do
	n=$(expr $n + 1)
# name format should be checked, maybe auto naming in future??
	name1=$(echo $rows  | awk 'BEGIN{FS="/"} {print $10}') 
	name2=$(echo $name1 | awk 'BEGIN{FS="_"} {print $2}')
	name3=$(echo $name1 | awk 'BEGIN{FS="_"} {print $3}')
	name4=$(echo $rows  | awk 'BEGIN{FS="/"} {print $12}')
	name=${name3}_${name2}_${name4}.root
	sed -e 's:NUMBER:'"${n}"':g' -e 's:TREENAME:'"${TreeDir}"':g' -e 's:INPUTPATH:'"${rows}"':g' -e 's:OUTPUTDIR:'"${OutPutDir}"':g' -e 's:OUTNAME:'"${name}"':g' runjobs.C > "${JobScriptDir}/runjobs_${n}.C" 
done
rm -f temp.out
