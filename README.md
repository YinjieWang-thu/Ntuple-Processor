# Ntuple-Processor version 20241013

This Ntuple Processor is created to process ntuple files, generate invariant mass spectrum, and make cut distribution for some quantity. 

This Ntuple Processor was originally created in https://github.com/AliceQuen/Ntuple-Processor.git, and I used it and made some modifications.

The myntuple class is made and modified for data in /home/storage0/users/junkaiqin/JpsiX3872/ntuple.

## User Guide

Firstly, complete the configuration in MakeJobScript.sh and bash it, which will create a job script folder include one Execute.C and several runjobs C file.

Secondly, edit the HistInfo.out file, add hist name and plot range. After that, complete the configuration of MakeMyntuple.sh(Set mode 1) and bash it. Then myntuple.C and myntuple.h appear in script folder.

Thirdly, modify the myntuple.C in script folder. Complete the argument in function Fill().

Fourthly, root the Execute.C file. Before that, edit the last for loop in Execute.C. That will decide the number of runjobs files executed.

Last, complete the configuration in MakeDrawRead.sh and bash it, then root the DrawDistribution.C in DrawRead folder.

## Add cut variables in myntuple.C in current script folder

Copy MakeMyntuple.sh and HistInfo.out in The script folder and edit HistInfo.out, just leave variables you want to add, then config the MakeMyntuple.sh(correct myntuple.C templete file name and
set mode to 2), then bash it, finish the blank in Fill( ), and you can root the Execute.C.
