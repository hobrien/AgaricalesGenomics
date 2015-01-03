#Run analyses necessary to assemble genomes and extract homologs

SHELL=/bin/bash

include config.mk


all : Analyses/Blobology/Bae_myo_phylum.png Analyses/Blobology/Cal_gam_phylum.png \
      Analyses/Blobology/Cla_fum_phylum.png Analyses/Blobology/Cli_gib_phylum.png \
      Analyses/Blobology/Cli_neb_phylum.png Analyses/Blobology/Ent_cly_phylum.png \
      Analyses/Blobology/Gym_jun_phylum.png Analyses/Blobology/Hyg_con_phylum.png \
      Analyses/Blobology/Inocyb_phylum.png Analyses/Blobology/Mac_cum_phylum.png \
      Analyses/Blobology/Meg_pla_phylum.png Analyses/Blobology/Mon_ror_phylum.png \
      Analyses/Blobology/Mycena_phylum.png Analyses/Blobology/Pte_sub_phylum.png \
      Analyses/Blobology/Tubaria_phylum.png Analyses/Trees

#Run RAxML on all alignments (this is done on the server)
Analyses/Trees : Analyses/Alignments/Phylip/*
	#export CLUSTER=$(CLUSTER) USER=$(USER); bash BuildTrees.bash
	touch Analyses/Trees

Analyses/Alignments/Phylip/AllConcatinatedProt.phy : Analyses/Scores/Mon_ror_scores.txt Analyses/Scores/Con_pu1_scores.txt \
        Analyses/Scores/Ser_laS73_scores.txt Analyses/Scores/Ser_laS79_scores.txt Analyses/Scores/Bae_myo_scores.txt \
        Analyses/Scores/Cal_gam_scores.txt Analyses/Scores/Cla_fum_scores.txt Analyses/Scores/Cli_gib_scores.txt \
        Analyses/Scores/Cli_neb_scores.txt Analyses/Scores/Ent_cly_scores.txt Analyses/Scores/Gym_jun_scores.txt \
        Analyses/Scores/Hyg_con_scores.txt Analyses/Scores/Inocyb_scores.txt Analyses/Scores/Mac_cum_scores.txt \
        Analyses/Scores/Meg_pla_scores.txt Analyses/Scores/Mycena_scores.txt Analyses/Scores/Pte_sub_scores.txt \
        Analyses/Scores/Tubaria_scores.txt Analyses/Scores/Guy_ne1_scores.txt
	bash AlignSeqs.bash
	python ConcatinateSeqs.py Analyses/Alignments/Gblocks Analyses/AllConcatinatedProt.fa > Analyses/partitions.txt
	python ConvertAln.py -i Analyses/AllConcatinatedProt.fa -f phylip -o Analyses/Alignments/Phylip/AllConcatinatedProt.phy
	touch Analyses/Alignments/Phylip

Analyses/Scores/%_scores.txt : Species/% Analyses/Copci1 Analyses/Annotation/%.aa
	export SPECIES=$(<F); $(MAKE) -C Analyses

Analyses/Annotation/%.aa : Species/% Analyses/Annotations/%.gff
	ssh $(VM) "/home/heath/Documents/augustus/scripts/getAnnoFasta.pl \
        /mnt/Bioinformatics/Mushrooms/AgaricalesGenomics/Analyses/Annotations/$(<F).gff"

Analyses/Annotations/%.gff : Species/% Analyses/Copci1 Analyses/Assemblies/%-scaffolds.fa
	 ssh $(VM) "/home/heath/Documents/augustus/bin/augustus --species=coprinus \
        /mnt/Bioinformatics/Mushrooms/AgaricalesGenomics/Analyses/Assemblies/$(<F)-scaffolds.fa \
        >/mnt/Bioinformatics/Mushrooms/AgaricalesGenomics/Analyses/Annotations/$(<F).gff"

Analyses/Blobology/%_phylum.png : Species/% Analyses/Assemblies/%-scaffolds.fa 
	bash Blobology.bash $(<F)

Analyses/Assemblies/%-scaffolds.fa : Species/% Reads/%_1.fastq Reads/%_2.fastq
	bash AssembleGenomes.bash $(<F)


##########################################################################################
#Download JGI data for species not included in original gene family analysis
Analyses/Assemblies/Con_pu1-scaffolds.fa Analyses/Annotations/Con_pu1.aa : cookies
	curl http://genome.jgi.doe.gov/Conpu1/download/Conpu1_AssemblyScaffolds.fasta.gz \
       -b cookies -c cookies |zcat > Analyses/Assemblies/Con_pu1-scaffolds.fa
	curl http://genome.jgi.doe.gov/Conpu1/download/Conpu1_GeneCatalog_proteins_20101116.aa.fasta.gz \
       -b cookies -c cookies |zcat > Analyses/Annotations/Con_pu1.aa

Analyses/Assemblies/Guy_ne1-scaffolds.fa Analyses/Annotations/Guy_ne1.aa : cookies
	curl http://genome.jgi.doe.gov/Guyne1/download/Guyne1_AssemblyScaffolds.fasta.gz \
       -b cookies -c cookies |zcat > Analyses/Assemblies/Guy_ne1-scaffolds.fa
	curl http://genome.jgi.doe.gov/Guyne1/download/Guyne1_GeneCatalog_proteins_20140406.aa.fasta.gz \
       -b cookies -c cookies |zcat > Analyses/Annotations/Guy_ne1.aa

Analyses/Assemblies/Ser_la73-scaffolds.fa Analyses/Annotations/Ser_la73.aa : cookies
	curl http://genome.jgi.doe.gov/SerlaS7_3_2/download/Serpula_lacrymans_S7_3_v2.unmasked.fasta.gz \
       -b cookies -c cookies |zcat > Analyses/Assemblies/Ser_la73-scaffolds.fa
	curl http://genome.jgi.doe.gov/SerlaS7_3_2/download/Serpula_lacrymans_S7_3_v2.proteins.fasta.gz \
       -b cookies -c cookies |zcat > Analyses/Annotations/Ser_la73.aa

Analyses/Assemblies/Ser_la79-scaffolds.fa Analyses/Annotations/Ser_la79.aa : cookies
	curl http://genome.jgi.doe.gov/SerlaS7_9_2/download/SerlaS7_9_2_AssemblyScaffolds.fasta.gz \
       -b cookies -c cookies |zcat > Analyses/Assemblies/Ser_la79-scaffolds.fa
	curl http://genome.jgi.doe.gov/SerlaS7_9_2/download/SerlaS7_9_2_GeneCatalog_proteins_20120319.aa.fasta.gz \
       -b cookies -c cookies |zcat > Analyses/Annotations/Ser_la79.aa

cookies :
	curl https://signon.jgi.doe.gov/signon/create --data-ascii login=$(JGI_SIGNON)\&password=$(JGI_PASSWORD) \
       -b cookies -c cookies > /dev/null
##########################################################################################

#extract Copci1 sequences from each homolog set and write to individual files
Analyses/Copci1 : JGI_210genes_renamed_by_Copci1_gene/Copci1_*.fa
	python ExtractSeqs.py JGI_210genes_renamed_by_Copci1_gene Copci1 $@
	touch Analyses/Copci1

clean :
	for file in `ls Analyses`; \
	do \
	  if [[ $$file != makefile.sh && $$file != README.md ]]; \
	  then \
	    rm -r $$file; \
	  fi; \
	done

