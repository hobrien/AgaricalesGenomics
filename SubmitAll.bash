for file in `ls Phylip`
do
   if [[ $file == *"AllConcatinatedProt"* ]]
   then
      qsub -v infile=$file shell/RunRaxmlLong.bash
      qsub -v infile=$file shell/RunRaxmlPartition.bash
   else   
      qsub -v infile=$file shell/RunRaxml.bash
   fi   
done


