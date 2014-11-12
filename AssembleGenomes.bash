for species in $@
do
  #Trim reads (Cla_fum and Tubaria only)
  if test species = 'Cla_fum' or test species = 'Tubaria'
  then
    java -jar Trimmomatic-0.32.jar PE \
      -threads 24 \
      -phred33 \
      -trimlog Trimomatic/${species}_log.txt
      Reads/${species}_1.fq Reads/${species}_2.fq \
      Trimomatic/${species}_1_paired.fq.gz Trimomatic/${species}_1_unpaired.fq.gz \
      Trimomatic/${species}_2_paired.fq.gz Trimomatic/${species}_2_unpaired.fq.gz \
      ILLUMINACLIP:Adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    mv Reads/${species}_1.fq Reads/${species}_untrimmed_1.fq
    mv Reads/${species}_2.fq Reads/${species}_untrimmed_2.fq
    gunzip -c Trimomatic/${species}_1_paired.fq.gz > Reads/${species}_1.fq
    gunzip -c Trimomatic/${species}_2_paired.fq.gz > Reads/${species}_2.fq
  fi
  
  #Assemble genomes
  abyss-pe \
    np=24 \
    k=31 \
    name=Assemblies/${species}.fa \
    in='Reads/${species}_1.fq Reads/${species}_2.fq'

  #Annotate contigs
  augustus --species=coprinus Assemblies/${species}.fa > Annotations/${species}.gff
  getAnnoFasta.pl Annotations/${species}.gff
  exonerate --model protein2genome \
    --bestn 1  \
    --verbose 0 \
    --showalignment no \
    --showvulgar no\
     --ryo ">%ti %td\n%tcs\n" \
     Reference_seqs/Copci_all.fa Annotations/${species}.aa
     > exonerate_results/${species}_exonerate/
done

