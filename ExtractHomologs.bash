for species in $@
do
  #Annotate contigs
  #
  #  I was not able to install augustus on my system (OSX 10.9), so I am running it thru
  #  virtual box.
  #  Setup instructions are here: http://www.lecloud.net/post/52224625343/the-ultimate-setup-guide-ubuntu-13-04-in-virtualbox
  #
  #  The command here needs to be changed to the following:
  #  ssh heath@ubuntu bash -c "'augustus --species=coprinus \
  #  /mnt/Bioinformatics/Mushrooms/AgaricalesGenomics/Analyses/Assemblies/${species}.fa \
  #  > /mnt/Bioinformatics/Mushrooms/AgaricalesGenomics/Analyses/Annotations/${species}.gff; \
  #  getAnnoFasta.pl /mnt/Bioinformatics/Mushrooms/AgaricalesGenomics/Analyses/Annotations/${species}.gff'"
  #
  if ! test -f Annotations/${species}.gff
  then
    augustus --species=coprinus Assemblies/${species}.fa > Annotations/${species}.gff
    getAnnoFasta.pl Annotations/${species}.gff
  fi
  #Identify homologs
  makeblastdb -dbtype prot -in Annotations/${species}.aa -parse_seqids
  for query in `ls Copci1`
  do
    exonerate --model protein2genome \
      --bestn 1  \
      --verbose 0 \
      --showalignment no \
      --showvulgar no\
      --ryo ">%ti %td\n%tcs\n" \
      Copci1/$query Assemblies/${species}.fa
      > exonerate_results/${species}_exonerate/${species}_${query}
    blastdbcmd -db Copci_all.fa \
      -entry_batch <(blastp \
        -query $query \
        -db Annotations/${species}.aa \
        -outfmt '6 sacc' \
        -max_target_seqs 1) \
        >augustus_results/${species}_split/${species}_${query}
  done
done