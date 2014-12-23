for species in $@
do
  #create all necessary folders
  for folder in Analyses/Assemblies Analyses/Annotations Analyses/exonerate_results \
    Analyses/exonerate_results/${species}_exonerate Analyses/augustus_results Analyses/augustus_results/${species}_split
  do
     if ! test -d $folder
    then
      mkdir $folder
    fi
  done
  
  #Trim reads (Cla_fum and Tubaria only)
  if test species = 'Cla_fum' || test species = 'Tubaria'
  then
    java -jar Trimmomatic-0.32.jar PE \
      -threads 24 \
      -phred33 \
      -trimlog Trimomatic/${species}_log.txt
      Reads/${species}_1.fastq Reads/${species}_2.fastq \
      Trimomatic/${species}_1_paired.fastq.gz Trimomatic/${species}_1_unpaired.fastq.gz \
      Trimomatic/${species}_2_paired.fastq.gz Trimomatic/${species}_2_unpaired.fastq.gz \
      ILLUMINACLIP:Adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    mv Reads/${species}_1.fastq Reads/${species}_untrimmed_1.fastq
    mv Reads/${species}_2.fastq Reads/${species}_untrimmed_2.fastq
    gunzip -c Trimomatic/${species}_1_paired.fastq.gz > Reads/${species}_1.fastq
    gunzip -c Trimomatic/${species}_2_paired.fastq.gz > Reads/${species}_2.fastq
  fi
  
  #Assemble genomes
  cd Analyses/Assemblies
  abyss-pe \
    np=24 \
    k=31 \
    name=${species} \
    in="../../Reads/${species}_1.fastq ../../Reads/${species}_2.fastq"
  cd ../
done

