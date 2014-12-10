#all species: Bae_myo Cal_gam Cla_fum Cli_gib Cli_neb Ent_cly Gym_jun Hyg_con Inocyb Mac_cum Meg_pla Mycena Pte_sub Tubaria
#Run analyses necessary to assemble genomes and extract homologs

SHELL=/bin/bash

Analyses/AllConcatinatedProt.fa : Mon_ror_scores.txt Con_pu1_scores.txt Ser_laS73_scores.txt Ser_laS79_scores.txt
	bash AlignSeqs.bash
	python ConcatinateSeqs.py Analyses/Alignments/Mafft Analyses/AllConcatinatedProt.fa

Mon_ror_scores.txt : Analyses/Copci1 Reads/Mon_ror_1.fastq Reads/Mon_ror_2.fastq
	export SPECIES=Mon_ror; $(MAKE) -C Analyses

Con_pu1_scores.txt : Analyses/Copci1 Reads/Con_pu1_1.fastq Reads/Con_pu1_2.fastq
	export SPECIES=Con_pu1; $(MAKE) -C Analyses

Ser_laS73_scores.txt : Analyses/Copci1 Reads/Ser_laS73_1.fastq Reads/Ser_laS73_2.fastq
	export SPECIES=Ser_laS73; $(MAKE) -C Analyses

Ser_laS79_scores.txt : Analyses/Copci1 Reads/Ser_laS79_1.fastq Reads/Ser_laS79_2.fastq
	export SPECIES=Ser_laS73; $(MAKE) -C Analyses

#extract Copci1 sequences from each homolog set and write to indvidual files
Analyses/Copci1 : JGI_210genes_renamed_by_Copci1_gene/Copci1_*.fa
	python ExtractSeqs.py JGI_210genes_renamed_by_Copci1_gene Copci1 $@
	touch Copci1



