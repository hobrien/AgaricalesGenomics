#create directories, if necessary
if ! test -d 'Analyses/Alignments'; then mkdir 'Analyses/Alignments'; fi
if ! test -d 'Analyses/Alignments/Mafft'; then mkdir 'Analyses/Alignments/Mafft'; fi
if ! test -d 'Analyses/all_seqs'; then mkdir 'Analyses/all_seqs'; fi
  
for gene in `ls JGI_210genes_renamed_by_Copci1_gene`
do
  #remove gap characters from reference gene sets
  cat JGI_210genes_renamed_by_Copci1_gene/$gene |tr -d - |grep -v ^$ >Analyses/all_seqs/${gene}
  #add new seqs
  for species in `ls Analyses/best_sequences`
    do
      cat Analyses/best_sequences/$species/${gene} >> Analyses/all_seqs/${gene}
    done
  #align seqs and write output to Analyses/Alignments/Mafft
  linsi Analyses/all_seqs/${gene} > Analyses/Alignments/Mafft/${gene}
done
