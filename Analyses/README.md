Analysis Pipeline Results
=========================

Typing 'make' in the parent directory should create the following:
------------------------------------------------------------------

Alignments/Augustus: Needle alignments of Augustus homologs to Copci reference genes
Alignments/Exonerate: Needle alignments of Exonerate homologs to Copci reference genes
Alignments/Gblocks: Gblocks trimmed MAFFT alignments (fasta formate)
Alignments/Mafft: MAFFT Multiple sequence alignments (fasta format)
Alignments/Phylip: Gblocks trimmed MAFFT alignments (relaxed Phylip format)
all_seqs: Unaligned sequences from all genomes (fasta format)
AllConcatinatedProt.fa: Concatinated alignment of all genes (fasta format)
Annotations: Augustus annotations (GFFs and translated AA seqs (fasta format))
Assemblies: Abyss assemblies, contigs >= 500 bp, and bowtie index files for large contigs
augustus_results: AA sequences of top blast hits from augustus for each reference gene
best_sequences: Augustus or Exonerate sequence with highest scoring Needle alignment
Copci1: AA sequences of references genes from Coprinopsis
exonerate_results: top exonerate result for each reference gene
needle_summary.txt: information about how many exonerate vs augustus results were selected for each sequence
Scores: information about which result was selected for each gene in each genome
Trees: RAxML results for each gene
