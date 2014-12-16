for file in `ls Analyses/Alignments/Phylip`
do
   if [[ $string == *"AllConcatinatedProt"* ]]
   then
      qsub -v infile=$file RunRaxmlLong.bash
   else   
      qsub -v infile=$file RunRaxml.bash
   fi   
done


