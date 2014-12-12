#Run analyses necessary to assemble genomes and extract homologs

SHELL=/bin/bash

Analyses/AllConcatinatedProt.fa : Mon_ror_scores.txt Con_pu1_scores.txt \
        Ser_laS73_scores.txt Ser_laS79_scores.txt Bae_myo_scores.txt Cal_gam_scores.txt \
        Cla_fum_scores.txt Cli_gib_scores.txt Cli_neb_scores.txt Ent_cly_scores.txt \
        Gym_jun_scores.txt Hyg_con_scores.txt Inocyb_scores.txt Mac_cum_scores.txt \
        Meg_pla_scores.txt Mycena_scores.txt Pte_sub_scores.txt Tubaria_scores.txt \
        Guy_ne1_scores.txt
	bash AlignSeqs.bash
	python ConcatinateSeqs.py Analyses/Alignments/Gblocks Analyses/AllConcatinatedProt.fa

Mon_ror_scores.txt : Analyses/Copci1 Reads/Mon_ror_1.fastq Reads/Mon_ror_2.fastq
	export SPECIES=Mon_ror; $(MAKE) -C Analyses

Con_pu1_scores.txt : Analyses/Copci1 Reads/Con_pu1_1.fastq Reads/Con_pu1_2.fastq
	export SPECIES=Con_pu1; $(MAKE) -C Analyses

Ser_laS73_scores.txt : Analyses/Copci1 Reads/Ser_laS73_1.fastq Reads/Ser_laS73_2.fastq
	export SPECIES=Ser_laS73; $(MAKE) -C Analyses

Ser_laS79_scores.txt : Analyses/Copci1 Reads/Ser_laS79_1.fastq Reads/Ser_laS79_2.fastq
	export SPECIES=Ser_laS79; $(MAKE) -C Analyses

Bae_myo_scores.txt : Analyses/Copci1 Reads/Bae_myo_1.fastq Reads/Bae_myo_2.fastq
	export SPECIES=Bae_myo; $(MAKE) -C Analyses

Cal_gam_scores.txt : Analyses/Copci1 Reads/Cal_gam_1.fastq Reads/Cal_gam_2.fastq
	export SPECIES=Cal_gam; $(MAKE) -C Analyses

Cla_fum_scores.txt : Analyses/Copci1 Reads/Cla_fum_1.fastq Reads/Cla_fum_2.fastq
	export SPECIES=Cla_fum; $(MAKE) -C Analyses

Cli_gib_scores.txt : Analyses/Copci1 Reads/Cli_gib_1.fastq Reads/Cli_gib_2.fastq
	export SPECIES=Cli_gib; $(MAKE) -C Analyses

Cli_neb_scores.txt : Analyses/Copci1 Reads/Cli_neb_1.fastq Reads/Cli_neb9_2.fastq
	export SPECIES=Cli_neb; $(MAKE) -C Analyses

Ent_cly_scores.txt : Analyses/Copci1 Reads/Ent_cly_1.fastq Reads/Ent_cly_2.fastq
	export SPECIES=Ent_cly; $(MAKE) -C Analyses

Gym_jun_scores.txt : Analyses/Copci1 Reads/Gym_jun_1.fastq Reads/Gym_jun_2.fastq
	export SPECIES=Ser_laS79; $(MAKE) -C Analyses

Hyg_con_scores.txt : Analyses/Copci1 Reads/Hyg_con9_1.fastq Reads/Hyg_con_2.fastq
	export SPECIES=Hyg_con; $(MAKE) -C Analyses

Inocyb_scores.txt : Analyses/Copci1 Reads/Inocyb_1.fastq Reads/Inocyb_2.fastq
	export SPECIES=Inocyb; $(MAKE) -C Analyses

Mac_cum_scores.txt : Analyses/Copci1 Reads/Mac_cum_1.fastq Reads/Mac_cum_2.fastq
	export SPECIES=Mac_cum; $(MAKE) -C Analyses

Meg_pla_scores.txt : Analyses/Copci1 Reads/Meg_pla_1.fastq Reads/Meg_pla_2.fastq
	export SPECIES=Meg_pla; $(MAKE) -C Analyses

Mycena_scores.txt : Analyses/Copci1 Reads/Mycena_1.fastq Reads/Mycena_2.fastq
	export SPECIES=Mycena; $(MAKE) -C Analyses

Pte_sub_scores.txt : Analyses/Copci1 Reads/Pte_sub_1.fastq Reads/Pte_sub_2.fastq
	export SPECIES=Pte_sub; $(MAKE) -C Analyses

Tubaria_scores.txt : Analyses/Copci1 Reads/Tubaria_1.fastq Reads/Tubaria_2.fastq
	export SPECIES=Tubaria; $(MAKE) -C Analyses

Guy_ne1.txt : Analyses/Copci1 Reads/Guy_ne1_1.fastq Reads/Guy_ne1_2.fastq
	export SPECIES=Guy_ne1; $(MAKE) -C Analyses

#extract Copci1 sequences from each homolog set and write to indvidual files
Analyses/Copci1 : JGI_210genes_renamed_by_Copci1_gene/Copci1_*.fa
	python ExtractSeqs.py JGI_210genes_renamed_by_Copci1_gene Copci1 $@
	touch Copci1



