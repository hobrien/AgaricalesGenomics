for species in $@
do
  if ! test -f Assemblies/${species}_l500.fa
  then
    fastaqual_select.pl -l 500 -f Assemblies/${species}-8.fa > Assemblies/${species}_l500.fa
  fi
  if ! test -f Blobology/${species}_10000.fa
  then
    fastaqual_select.pl -f Assemblies/${species}_l500.fa -s r -n 10000 >Blobology/${species}_10000.fa
  fi
  blastn -task megablast -query Blobology/${species}_10000.fa -db nt -evalue 1e-5 -num_threads 8 -max_target_seqs 1 -outfmt '6 qseqid staxids' -out Blobology/${species}_10000.bl
  if ! test -f Assemblies/${species}.1.bt2 || \
     ! test -f Assemblies/${species}.2.bt2 || \
     ! test -f Assemblies/${species}.3.bt2 || \
     ! test -f Assemblies/${species}.4.bt2  || \
     ! test -f Assemblies/${species}.rev.1.bt2 || \
     ! test -f Assemblies/${species}.rev.2.bt2
  then
    bowtie2-build Assemblies/${species}_l500.fa Assemblies/${species}
  fi
  if ! test -f Blobology/${species}.bam
  then
    bowtie2 -x Assemblies/${species} --very-fast-local -k 1 -t -p 12 --reorder --mm \
      -U <(shuffleSequences_fastx.pl 4 Reads/${species}_1.fastq Reads/${species}_2.fastq) \
      | samtools view -S -b -T Assemblies/${species}_l500.fa - > Blobology/${species}.bam
  fi
  if ! test -f Blobology/${species}_blob.txt
  then
    gc_cov_annotate.pl --blasttaxid Blobology/${species}_10000.bl --assembly Assemblies/${species}_l500.fa --bam Blobology/${species}.bam --out Blobology/${species}_blob.txt --taxdump ~/Database/
  fi
  if ! test -f Blobology/${species}_phylum.png
  then
    makeblobplot.R Blobology/${species}_blob.txt 0.01 taxlevel_phylum Blobology/${species}_phylum.png
  fi
  if ! test -f Blobology/${species}_order.png
  then
    makeblobplot.R Blobology/${species}_blob.txt 0.01 taxlevel_order Blobology/${species}_order.png
  fi
  if ! test -f Blobology/${species}_species.png
  then
    makeblobplot.R Blobology/${species}_blob.txt 0.01 taxlevel_species Blobology/${species}_species.png
  fi
done

