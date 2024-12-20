#!/bin/bash
#version 20241013 modified by wangyinjie

# This script is used to gentrate or edit myntuple.C

############################### Configuration #################################
myntuple_H='myntuple.h' # myntuple.h templete file 
myntuple_C='myntuple_template.C' # myntuple.C templete file
Mode='1' # Job Mode 0:generate a Hist info templete file 1: Generate new work script 2: Replace old script in current folder
hist_OUT='HistInfo.out' # Hist info file
JobScriptDir='/home/storage2/users/wangyinjie/Ntuple-Processor-main-copy/run2016' # Directory to store Job Script, where runjobs.C files exists
# Such a Dir should be created by MakeJobScript.sh. DO NOT INCLUDE last / in JobScriptDir 
###############################################################################

if [[ ! -d ${JobScriptDir} && $Mode -ne 0 && $Mode -ne 2 ]]
then
    	echo "Fatal: Parameter JobScriptDir is missed!!"
	Mode=-1
fi
if [ $Mode -eq 0 ]
then
	echo -e "--- Distription in first line ---\n--- Mode in MakeMyntuple.sh ---\nHistName/min/max" > HistInfo.out	
	echo "HistInfo.out is created"
fi

if [ $Mode -eq 1 ]
then
	cp $myntuple_H $JobScriptDir/myntuple.h
	cp $myntuple_C $JobScriptDir/C_temp.C
	sed -i -e '1i//This script is automaticly generated by MakeMyntuple' $JobScriptDir/C_temp.C		
	cat $hist_OUT | while read rows
	do
		if [[ $rows =~ ---.*--- ]]
		then 
			sleep 0.001
		else
			h_name=$(echo $rows | awk 'BEGIN{FS="/"} {print $1}')
			h_min=$(echo $rows |awk 'BEGIN{FS="/"} {print $2}')
			h_max=$(echo $rows | awk 'BEGIN{FS="/"} {print $3}')
			sed -i -e '/HIST_RANGE/'"a\   double max_${h_name}=${h_max};\n   double min_${h_name}=${h_min};" $JobScriptDir/C_temp.C	
			sed -i -e '/HIST_DEFINE/'"a\   TH1F *h_sig_${h_name} = new TH1F(\"h_sig_${h_name}\", \"h_sig_${h_name}\", 100, min_${h_name}, max_${h_name});\n   TH1F *h_bkg_${h_name} = new TH1F(\"h_bkg_${h_name}\", \"h_bkg_${h_name}\", 100, min_${h_name}, max_${h_name});"  $JobScriptDir/C_temp.C
			sed -i -e '/FILL_SIG/'"a\ \t\t\th_sig_${h_name}->Fill();//Edit what you want to fill here"	$JobScriptDir/C_temp.C
			sed -i -e '/FILL_BKG/'"a\ \t\t\th_bkg_${h_name}->Fill();//Edit what you want to fill here"	$JobScriptDir/C_temp.C
		fi
	done	
	rm $JobScriptDir/myntuple.C
	cp $JobScriptDir/C_temp.C $JobScriptDir/myntuple.C
	rm $JobScriptDir/C_temp.C
fi

if [ $Mode -eq 2 ]
then
	cp $myntuple_C C_temp.C
	sed -i -e '1i//This script is automaticly generated by MakeMyntuple' C_temp.C		
	cat $hist_OUT | while read rows
	do
		if [[ $rows =~ ---.*--- ]]
		then 
			sleep 0.001
		else
			h_name=$(echo $rows | awk 'BEGIN{FS="/"} {print $1}')
			h_min=$(echo $rows |awk 'BEGIN{FS="/"} {print $2}')
			h_max=$(echo $rows | awk 'BEGIN{FS="/"} {print $3}')
			sed -i -e '/HIST_RANGE/'"a\   double max_${h_name}=${h_max};\n   double min_${h_name}=${h_min};" C_temp.C	
			sed -i -e '/HIST_DEFINE/'"a\   TH1F *h_sig_${h_name} = new TH1F(\"h_sig_${h_name}\", \"h_sig_${h_name}\", 100, min_${h_name}, max_${h_name});\n   TH1F *h_bkg_${h_name} = new TH1F(\"h_bkg_${h_name}\", \"h_bkg_${h_name}\", 100, min_${h_name}, max_${h_name});"  C_temp.C
			sed -i -e '/FILL_SIG/'"a\ \t\t\th_sig_${h_name}->Fill();//Edit what you want to fill here"	C_temp.C
			sed -i -e '/FILL_BKG/'"a\ \t\t\th_bkg_${h_name}->Fill();//Edit what you want to fill here"	C_temp.C
		fi
	done	
	rm myntuple.C
	cp C_temp.C myntuple.C
	rm C_temp.C
fi
