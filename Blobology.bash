for species in $@
do
  #select contigs >= 500 bp
  if ! test -f Analyses/Assemblies/${species}_l500.fa
  then
    fastaqual_select.pl -l 500 -f Analyses/Assemblies/${species}-8.fa > Analyses/Assemblies/${species}_l500.fa
  fi
  #select sample of 10,000 contigs
  if ! test -f Analyses/Blobology/${species}_10000.fa
  then
    fastaqual_select.pl -f Analyses/Assemblies/${species}_l500.fa -s r -n 10000 > Analyses/Blobology/${species}_10000.fa
  fi
  #blast sample of contigs against nt database
  if ! test -f Analyses/Blobology/${species}_10000.bl
  then
    blastn -task megablast -query Analyses/Blobology/${species}_10000.fa -db nt -evalue 1e-5 -num_threads 8 -max_target_seqs 1 -outfmt '6 qseqid staxids' -out Analyses/Blobology/${species}_10000.bl
  fi
  #index all contig over 500 bp and map reads to determine coverage
  if ! test -f Analyses/Assemblies/${species}.1.bt2 || \
     ! test -f Analyses/Assemblies/${species}.2.bt2 || \
     ! test -f Analyses/Assemblies/${species}.3.bt2 || \
     ! test -f Analyses/Assemblies/${species}.4.bt2  || \
     ! test -f Analyses/Assemblies/${species}.rev.1.bt2 || \
     ! test -f Analyses/Assemblies/${species}.rev.2.bt2
  then
    bowtie2-build Analyses/Assemblies/${species}_l500.fa Analyses/Assemblies/${species}
  fi
  if test -f Reads/${species}_1.fastq && test -f Reads/${species}_2.fastq && ! test -f Analyses/Blobology/${species}.bam
  then
    bowtie2 -x Analyses/Assemblies/${species} --very-fast-local -k 1 -t -p 12 --reorder --mm \
      -U <(shuffleSequences_fastx.pl 4 Reads/${species}_1.fastq Reads/${species}_2.fastq) \
      | samtools view -S -b -T Analyses/Assemblies/${species}_l500.fa - > Analyses/Blobology/${species}.bam
  fi
  #calculate coverage and GC content
  if test -f Analyses/Blobology/${species}.bam && ! test -f Analyses/Blobology/${species}_blob.txt
  then
    gc_cov_annotate.pl --blasttaxid Analyses/Blobology/${species}_10000.bl --assembly Analyses/Assemblies/${species}_l500.fa --bam Analyses/Blobology/${species}.bam --out Analyses/Blobology/${species}_blob.txt --taxdump ~/Database/
  fi
  #plot GC vs coverage mapping phylum of blast hit to point colour
  if test -f Analyses/Blobology/${species}_blob.txt && ! test -f Analyses/Blobology/${species}_phylum.png
  then
    makeblobplot.R Analyses/Blobology/${species}_blob.txt 0.01 taxlevel_phylum Analyses/Blobology/${species}_phylum.png
  fi
  #plot GC vs coverage mapping order of blast hit to point colour
  if test -f Analyses/Blobology/${species}_blob.txt && ! test -f Analyses/Blobology/${species}_order.png
  then
    makeblobplot.R Analyses/Blobology/${species}_blob.txt 0.01 taxlevel_order Analyses/Blobology/${species}_order.png
  fi
  #plot GC vs coverage mapping species of blast hit to point colour
  if test -f Analyses/Blobology/${species}_blob.txt && ! test -f Analyses/Blobology/${species}_species.png
  then
    makeblobplot.R Analyses/Blobology/${species}_blob.txt 0.01 taxlevel_species Analyses/Blobology/${species}_species.png
  fi
done

