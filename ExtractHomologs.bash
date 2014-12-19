for species in $@
do
  #Identify homologs
  makeblastdb -dbtype prot -in Annotations/${species}.aa -parse_seqids
  if ! test -d exonerate_results; then mkdir exonerate_results; fi
  if ! test -d exonerate_results/${species}_exonerate; then mkdir exonerate_results/${species}_exonerate; fi
  if ! test -d augustus_results; then mkdir augustus_results; fi
  if ! test -d augustus_results/${species}_split; then mkdir augustus_results/${species}_split; fi
  for query in `ls Copci1`
  do
    gene=$(echo $query | cut -d. -f 1)
    echo ">kew|${species}|${gene}" > exonerate_results/${species}_exonerate/${species}_${query}
    echo ">kew|${species}|${gene}" > augustus_results/${species}_split/${species}_${query}
    exonerate --model protein2genome \
      --bestn 1  \
      --verbose 0 \
      --showalignment no \
      --showvulgar no\
      --ryo "%tcs\n" \
      Copci1/$query Assemblies/${species}-scaffolds.fa \
      | perl ../translate.pl \
      >> exonerate_results/${species}_exonerate/${species}_${query}
    blastdbcmd -db Annotations/${species}.aa \
      -outfmt %s \
      -entry_batch <(blastp \
        -query Copci1/$query \
        -db Annotations/${species}.aa \
        -outfmt '6 sacc' \
        -max_target_seqs 1) \
      >> augustus_results/${species}_split/${species}_${query}
  done
done