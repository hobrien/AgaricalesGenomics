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
      Analyses/Blobology/Tubaria_phylum.png Analyses/Alignments/Phylip/AllConcatinatedProt.phy

Analyses/Blobology/%_phylum.png : Species/% Analyses/Assemblies/%-scaffolds.fa
	bash Blobology.bash $(<F)

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

Analyses/Scores/%_scores.txt : Species/% Analyses/Copci1 Reads/%_1.fastq Reads/%_2.fastq
	export SPECIES=$(<F); $(MAKE) -C Analyses

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

