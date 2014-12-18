#Run analyses necessary to assemble genomes and extract homologs

SHELL=/bin/bash

include config.mk

#Run RAxML on all alignments (this is done on the server)
Analyses/Trees : Analyses/Alignments/Phylip/*
	export CLUSTER=$(CLUSTER) USER=$(USER); bash BuildTrees.bash
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

Analyses/Scores/Mon_ror_scores.txt : Analyses/Copci1 Reads/Mon_ror_1.fastq Reads/Mon_ror_2.fastq
	export SPECIES=Mon_ror; $(MAKE) -C Analyses

Analyses/Scores/Con_pu1_scores.txt : Analyses/Copci1 Reads/Con_pu1_1.fastq Reads/Con_pu1_2.fastq
	export SPECIES=Con_pu1; $(MAKE) -C Analyses

Analyses/Scores/Ser_laS73_scores.txt : Analyses/Copci1 Reads/Ser_laS73_1.fastq Reads/Ser_laS73_2.fastq
	export SPECIES=Ser_laS73; $(MAKE) -C Analyses

Analyses/Scores/Ser_laS79_scores.txt : Analyses/Copci1 Reads/Ser_laS79_1.fastq Reads/Ser_laS79_2.fastq
	export SPECIES=Ser_laS79; $(MAKE) -C Analyses

Analyses/Scores/Bae_myo_scores.txt : Analyses/Copci1 Reads/Bae_myo_1.fastq Reads/Bae_myo_2.fastq
	export SPECIES=Bae_myo; $(MAKE) -C Analyses

Analyses/Scores/Cal_gam_scores.txt : Analyses/Copci1 Reads/Cal_gam_1.fastq Reads/Cal_gam_2.fastq
	export SPECIES=Cal_gam; $(MAKE) -C Analyses

Analyses/Scores/Cla_fum_scores.txt : Analyses/Copci1 Reads/Cla_fum_1.fastq Reads/Cla_fum_2.fastq
	export SPECIES=Cla_fum; $(MAKE) -C Analyses

Analyses/Scores/Cli_gib_scores.txt : Analyses/Copci1 Reads/Cli_gib_1.fastq Reads/Cli_gib_2.fastq
	export SPECIES=Cli_gib; $(MAKE) -C Analyses

Analyses/Scores/Cli_neb_scores.txt : Analyses/Copci1 Reads/Cli_neb_1.fastq Reads/Cli_neb_2.fastq
	export SPECIES=Cli_neb; $(MAKE) -C Analyses

Analyses/Scores/Ent_cly_scores.txt : Analyses/Copci1 Reads/Ent_cly_1.fastq Reads/Ent_cly_2.fastq
	export SPECIES=Ent_cly; $(MAKE) -C Analyses

Analyses/Scores/Gym_jun_scores.txt : Analyses/Copci1 Reads/Gym_jun_1.fastq Reads/Gym_jun_2.fastq
	export SPECIES=Ser_laS79; $(MAKE) -C Analyses

Analyses/Scores/Hyg_con_scores.txt : Analyses/Copci1 Reads/Hyg_con_1.fastq Reads/Hyg_con_2.fastq
	export SPECIES=Hyg_con; $(MAKE) -C Analyses

Analyses/Scores/Inocyb_scores.txt : Analyses/Copci1 Reads/Inocyb_1.fastq Reads/Inocyb_2.fastq
	export SPECIES=Inocyb; $(MAKE) -C Analyses

Analyses/Scores/Mac_cum_scores.txt : Analyses/Copci1 Reads/Mac_cum_1.fastq Reads/Mac_cum_2.fastq
	export SPECIES=Mac_cum; $(MAKE) -C Analyses

Analyses/Scores/Meg_pla_scores.txt : Analyses/Copci1 Reads/Meg_pla_1.fastq Reads/Meg_pla_2.fastq
	export SPECIES=Meg_pla; $(MAKE) -C Analyses

Analyses/Scores/Mycena_scores.txt : Analyses/Copci1 Reads/Mycena_1.fastq Reads/Mycena_2.fastq
	export SPECIES=Mycena; $(MAKE) -C Analyses

Analyses/Scores/Pte_sub_scores.txt : Analyses/Copci1 Reads/Pte_sub_1.fastq Reads/Pte_sub_2.fastq
	export SPECIES=Pte_sub; $(MAKE) -C Analyses

Analyses/Scores/Tubaria_scores.txt : Analyses/Copci1 Reads/Tubaria_1.fastq Reads/Tubaria_2.fastq
	export SPECIES=Tubaria; $(MAKE) -C Analyses

Analyses/Scores/Guy_ne1_scores.txt : Analyses/Copci1 Reads/Guy_ne1_1.fastq Reads/Guy_ne1_2.fastq
	export SPECIES=Guy_ne1; $(MAKE) -C Analyses

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

