#Run analyses necessary to assemble genomes and extract homologs

SHELL=/bin/bash

Mon_ror_scores.txt : Analyses/Copci1 Reads/Mon_ror_1.fastq Reads/Mon_ror_1.fastq
	export SPECIES=Mon_ror; $(MAKE) -C Analyses

#extract Copci1 sequences from each homolog set and write to indvidual files
Analyses/Copci1 : JGI_210genes_renamed_by_Copci1_gene/Copci1_*.fa
	python ExtractSeqs.py JGI_210genes_renamed_by_Copci1_gene Copci1 $@
	touch Copci1



