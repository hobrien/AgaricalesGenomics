for file in `ls $HOME/Alignments`
do
   if [[ $string == *"AllConcatinatedProt"* ]]
   then
      qsub -v infile=$file $HOME/shell/RunRaxmlLong.bash
   else   
      qsub -v infile=$file $HOME/shell/RunRaxml.bash
   fi   
done


