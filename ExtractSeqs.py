#!/usr/local/bin/python

"""This will extract sequences from files in the folder given as the first argument with
with names that include the second argument as a search term and write each to an outfile
in the folder given as the third argument, using the search term and the third part of the
sequence name as the file name

"""

import sys, os
from glob import glob
from Bio import SeqIO

usage = "ExtractSeqs.py INPUT_FOLDER SEARCH_TERM OUTPUT_FOLEDER"

try:
  infolder=sys.argv[1]
  species=sys.argv[2]
  outfolder=sys.argv[3]
except IndexError:
  sys.exit(usage)
  
if not os.path.exists(outfolder):
  os.makedirs(outfolder)
  
for infile in glob(infolder + '/*.fa'):
  for seq_record in SeqIO.parse(infile, "fasta"):
    if species in seq_record.id:
      outfile = os.path.join(outfolder, '_'.join((species, seq_record.id.split('|')[2])) + '.fa')
      SeqIO.write(seq_record, outfile, 'fasta')
