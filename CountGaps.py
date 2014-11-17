import sys
from os import path
from glob import glob
from Bio import SeqIO

infile=sys.argv[1]

for seq_record in SeqIO.parse(infile, "fasta"):
  print seq_record.id, 100-(float(seq_record.seq.count('X')+seq_record.seq.count('-'))/len(seq_record.seq) * 100)
