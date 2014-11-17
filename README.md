AgaricalesGenomics
==================

Scripts and data used for the analyses presented in Tales from the crypt: "Genome mining from fungarium specimens to identify low copy loci for phylogenomics of the Agaricales"


Prerequisites
-------------

*AbySS (http://www.bcgsc.ca/platform/bioinfo/software/abyss)
*Augustus (http://augustus.gobics.de)
*Biopython (http://biopython.org)
*Blast+ (http://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
*Blobology (http://nematodes.org/bioinformatics/blobology)
*Bowtie2 (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
*EMBOSS (http://emboss.sourceforge.net/)
*Exonerate (https://www.ebi.ac.uk/~guy/exonerate/index.html)
*R (http://www.r-project.org)
*SAMTools (http://samtools.sourceforge.net)
*Trimmomatic (http://www.usadellab.org/cms/?page=trimmomatic)

Scripts
-------
*AssembleGenomes.bash (AbySS assembly, Augustus gene prediction, Exonerate)
*Blobology.bash (maps reads to contigs, then plots GC vs. coverage and colour codes by blast hit)
*CountGaps.py (Calculates the percentage of gap characters for each sequence in an alignment)
*ExtractSeqs.py (Extracts sequences belonging to the specified species from a datafile and writes each to a separate file)
*RunNeedle.bash (aligns Augustus/Exonerate homologs to references and selects highest scoring homolog)

Datasets
--------
*FastQC_reports.zip (FastQC results for each sequence file)

