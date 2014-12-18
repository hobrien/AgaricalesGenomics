#Run analyses necessary to assemble genomes and extract homologs

SHELL=/bin/bash
include ../config.mk

#Align homologs to references and select sequences with the highest alignment scores
$(SPECIES)_scores.txt : augustus_results/$(SPECIES)_split exonerate_results/$(SPECIES)_exonerate/
	bash ../RunNeedle.bash $(SPECIES)

#Run blobology
#Blobology/$(SPECIES)_blob.txt Blobology/$(SPECIES)_order.png Blobology/$(SPECIES)_phylum.png Blobology/$(SPECIES)_species.png : Assemblies/$(SPECIES)-scaffolds.fa
#	bash ../Blobology.bash $(SPECIES)

#Extract homologs
augustus_results/$(SPECIES)_split exonerate_results/$(SPECIES)_exonerate: Assemblies/$(SPECIES)-scaffolds.fa Copci1/*
	export VM=$(VM); bash ../ExtractHomologs.bash $(SPECIES)
	touch $@

#Assemble genomes
Assemblies/$(SPECIES)-scaffolds.fa : ../Reads/$(SPECIES)_1.fastq ../Reads/$(SPECIES)_2.fastq
	bash ../AssembleGenomes.bash $(SPECIES)
	touch $@

