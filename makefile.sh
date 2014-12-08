#Run analyses necessary to assemble genomes and extract homologs

SHELL=/bin/bash
all :
	export SPECIES=Mon_ror; $(MAKE) -C Analyses

#extract Copci1 sequences from each homolog set and write to indvidual files
Copci1 : JGI_210genes_renamed_by_Copci1_gene/Copci1_*.fa
	python ../ExtractSeqs.py JGI_210genes_renamed_by_Copci1_gene $@ $@
	touch Copci1



