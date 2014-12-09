#all species: Bae_myo Cal_gam Cla_fum Cli_gib Cli_neb Ent_cly Gym_jun Hyg_con Inocyb Mac_cum Meg_pla Mycena Pte_sub Tubaria
#Run analyses necessary to assemble genomes and extract homologs

SHELL=/bin/bash

Analyses/AllConcatinatedProt.fa : Mon_ror_scores.txt
	bash AlignSeqs.bash
	python ConcatinateSeqs.py Analyses/Alignments/Mafft Analyses/AllConcatinatedProt.fa

Mon_ror_scores.txt : Analyses/Copci1 Reads/Mon_ror_1.fastq Reads/Mon_ror_1.fastq
	export SPECIES=Mon_ror; $(MAKE) -C Analyses

#extract Copci1 sequences from each homolog set and write to indvidual files
Analyses/Copci1 : JGI_210genes_renamed_by_Copci1_gene/Copci1_*.fa
	python ExtractSeqs.py JGI_210genes_renamed_by_Copci1_gene Copci1 $@
	touch Copci1



