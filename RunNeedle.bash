#all species: Bae_myo Cal_gam Cla_fum Cli_gib Cli_neb Ent_cly Gym_jun Hyg_con Inocyb Mac_cum Meg_pla Mycena Pte_sub Tubaria
if ! test -d 'best_sequences'; then mkdir 'best_sequences'; fi
if ! test -d 'best_sequences/${species}'; then mkdir 'best_sequences/${species}'; fi
if ! test -d 'Alignments'; then  mkdir 'Alignments'; fi
if ! test -d 'Alignments/Exonerate'; then mkdir 'Alignments/Exonerate'; fi
if ! test -d 'Alignments/Augustus'; then mkdir 'Alignments/Augustus'; fi
if test -d 'blastp_augustus_results/Inocybeae_split'
then
  mv blastp_augustus_results/Inocybeae_split/ blastp_augustus_results/Inocyb_split/
fi
if test -d 'blastp_augustus_results/Clav_fumo_split'
then
  mv blastp_augustus_results/Clav_fumo_split/ blastp_augustus_results/Cla_fum_split/
fi
  
for species in $@
do
  #`./RenameFiles.py blastp_augustus_results/${species}_split`
  #`./RenameFiles.py exonerate_results/${species}_exonerate`  
  `echo "gene, Augustus, Exonerate" > ${species}_scores.txt`
  exonerate_better=0
  augustus_better=0
  identical_score=0
  for file in `ls Copci1`
  do
    gene=$(echo $file |cut -d'_' -f2)
    gene=$(echo $gene |cut -d'.' -f1)
    #Align Exonerate sequence and extract the score (set score = 0 if no sequence)
    #If duplicate sequences are present, only consider the first
    exonerate_file=$(ls exonerate_results/${species}_exonerate |grep ${species}_Copci1_${gene}[_.] |head -1)
    exonerate_file=exonerate_results/${species}_exonerate/${exonerate_file}
    if test -f $exonerate_file
    then
      seqname=$(echo $exonerate_file |cut -d'.' -f1 |cut -d'/' -f 3)  
      if ! test -f "Alignments/Exonerate/$seqname.needle"
      then 
        #echo "needle -gapopen 10 -gapextend 0.5 -outfile Alignments/Exonerate/$seqname.needle exonerate_results/${species}_exonerate/$file Copci1/Copci1_${gene}.fa"
        `needle -gapopen 10 -gapextend 0.5 -outfile Alignments/Exonerate/$seqname.needle $exonerate_file Copci1/Copci1_${gene}.fa`
      fi
      exonerate_score=$(grep Score Alignments/Exonerate/$seqname.needle | cut -d' ' -f 3 | tail -1)
    else
      exonerate_score=0
    fi
    #Align Augustus sequence and extract the score (set score = 0 if no sequence)
    augustus_file=augustus_results/${species}_split/${species}_Copci1_${gene}.fa
    if test -f $augustus_file
    then
      echo $augustus_file
      seqname=$(echo $augustus_file |cut -d'.' -f1 |cut -d'/' -f 3)  
      if ! test -f "Alignments/Augustus/$seqname.needle"
      then 
      #echo "needle -gapopen 10 -gapextend 0.5 -outfile Alignments/Augustus/$seqname.needle blastp_augustus_results/${species}_split/$file Copci1/Copci1_${gene}.fa"
      `needle -gapopen 10 -gapextend 0.5 -outfile Alignments/Augustus/$seqname.needle $augustus_file Copci1/Copci1_${gene}.fa`
      fi
      augustus_score=$(grep Score Alignments/Augustus/$seqname.needle | cut -d' ' -f 3)
    else
      augustus_score=0
    fi
    `echo "Copci1_${gene}, $augustus_score, $exonerate_score" >> ${species}_scores.txt`
    if [ "$(echo $augustus_score '>' $exonerate_score | bc -l)" -eq 1 ]
    then
      augustus_better=$(echo $augustus_better + 1 |bc)
      cat $augustus_file > best_sequences/${species}/$file
    elif [ "$(echo $augustus_score '<' $exonerate_score | bc -l)" -eq 1 ]
    then
      exonerate_better=$(echo $exonerate_better + 1 |bc)
      cat $exonerate_file > best_sequences/${species}/$file
    elif test -f $augustus_file
    then
      identical_score=$(echo $identical_score + 1 |bc)
      cat $augustus_file > best_sequences/${species}/$file
    else
      echo "${species}_Copci1$gene: no homolog"
    fi
  done
  echo "$species, $augustus_better, $exonerate_better, $identical_score" >> needle_summary.txt
done

