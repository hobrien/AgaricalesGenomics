#create directories, if necessary
if ! test -d 'Analyses/Alignments'; then mkdir 'Analyses/Alignments'; fi
if ! test -d 'Analyses/Alignments/Mafft'; then mkdir 'Analyses/Alignments/Mafft'; fi
if ! test -d 'Analyses/Alignments/Gblocks'; then mkdir 'Analyses/Alignments/Gblocks'; fi
if ! test -d 'Analyses/Alignments/Phylip'; then mkdir 'Analyses/Alignments/Phylip'; fi
if ! test -d 'Analyses/all_seqs'; then mkdir 'Analyses/all_seqs'; fi
  
for gene in `ls JGI_210genes_renamed_by_Copci1_gene`
do
  #remove gap characters from reference gene sets ( tr -d - ), remove blank lines ( grep -v ^$ )
  #and remove everything except species identifier from sequencer names (perl StripNames.pl)
  cat JGI_210genes_renamed_by_Copci1_gene/$gene | tr -d - | grep -v ^$ | perl StripNames.pl > Analyses/all_seqs/${gene}
  
  #add new seqs
  for species in `ls Analyses/best_sequences`
    do
      cat Analyses/best_sequences/$species/${gene} | perl StripNames.pl >> Analyses/all_seqs/${gene}
    done
  
  #align seqs and write output to Analyses/Alignments/Mafft
  linsi Analyses/all_seqs/${gene} > Analyses/Alignments/Mafft/${gene}
  
  #Run Gblocks
  Gblocks Analyses/Alignments/Mafft/${gene} -t=p -b5=h
  mv Analyses/Alignments/Mafft/${gene}-gb Analyses/Alignments/Gblocks/${gene}
  python ConvertAln.py -i Analyses/Alignments/Gblocks/${gene} -f phylip \
      -o Analyses/Alignments/Phylip/${gene}
done
