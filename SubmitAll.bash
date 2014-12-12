for file in `ls $HOME/Alignments`
do
   qsub -v infile=$file $HOME/shell/RunRaxml.bash
done


