#!/bin/bash

for file in `ls Phylip`
do
   if [[ $file == *"AllConcatinatedProt"* ]]
   then
      qsub -v infile=$file shell/RunRaxmlPartition.bash
      qsub -v infile=$file shell/RunRaxmlLong.bash
   else
      qsub -v infile=$file shell/RunRaxml.bash
   fi   
done
