for file in `ls Phylip`
do
   if [[ $string == *"AllConcatinatedProt"* ]]
   then
      qsub -v infile=$file RunRaxmlLong.bash
      qsub -v infile=$file RunRaxmlPartition.bash
   else   
      qsub -v infile=$file RunRaxml.bash
   fi   
done


