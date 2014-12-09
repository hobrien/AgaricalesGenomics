#create directories, if necessary
if ! test -d 'Alignments'; then mkdir 'Alignments'; fi
if ! test -d 'Alignments/Mafft'; then mkdir 'Alignments/Mafft'; fi
if ! test -d 'all_seqs'; then mkdir 'all_seqs'; fi
  
for gene in `ls JGI_210genes_renamed_by_Copci1_gene`
do
  #remove gap characters from reference gene sets
  cat JGI_210genes_renamed_by_Copci1_gene/$gene |tr -d - |grep -v ^$ >all_seqs/${gene}.fa
  #add new seqs
  for species in `ls best_sequences`
    do
      cat best_sequences/$species/${gene}.fa >> all_seqs/${gene}.fa
    done
  #align seqs and write output to Alignments/Mafft
  linsi all_seqs/${gene}.fa > Alignments/Mafft/${gene}.fa
done
