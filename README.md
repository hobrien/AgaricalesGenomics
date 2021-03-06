AgaricalesGenomics
==================

Scripts and data used for the analyses presented in Tales from the crypt: "Genome mining from fungarium specimens to identify low copy loci for phylogenomics of the Agaricales"

Instructions
------------

-Modify config.mk with login info for virtual machine and cluster
-Make ensure that public ssh key is shared with cluster and VM so that no password is required (see http://www.linuxproblem.org/art_9.html)
-Type make

Prerequisites
-------------

-AbySS (http://www.bcgsc.ca/platform/bioinfo/software/abyss)

-Augustus (http://augustus.gobics.de)

-BioPerl (http://www.bioperl.org)

-Biopython (http://biopython.org)

-Blast+ (http://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download)

-Blobology (http://nematodes.org/bioinformatics/blobology)

-Bowtie2 (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)

-EMBOSS (http://emboss.sourceforge.net/)

-Exonerate (https://www.ebi.ac.uk/~guy/exonerate/index.html)

-Gblocks (http://molevol.cmima.csic.es/castresana/Gblocks.html)

-MAFFT (http://mafft.cbrc.jp/alignment/software/) 

-R (http://www.r-project.org)

-SAMTools (http://samtools.sourceforge.net)

-Trimmomatic (http://www.usadellab.org/cms/?page=trimmomatic)

Scripts
-------
-AssembleGenomes.bash (AbySS assembly and trimming where necessary)

-Blobology.bash (maps reads to contigs, then plots GC vs. coverage and colour codes by blast hit)

-CountGaps.py (Calculates the percentage of gap characters for each sequence in an alignment)

-ExtractHomologs.bash (Augustus gene prediction plus blastp, Exonerate)

-ExtractSeqs.py (Extracts sequences belonging to the specified species from a datafile and writes each to a separate file)

-RunNeedle.bash (aligns Augustus/Exonerate homologs to references and selects highest scoring homolog)

-translate.pl (translate DNA sequences into AA sequences)

Datasets
--------
-FastQC_reports.zip (FastQC results for each sequence file)

