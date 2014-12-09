#!/usr/local/bin/python

"""
This will concatinate sequences from alignments based on the second part of their name

"""

import sys, os
from glob import glob
from Bio import SeqIO

usage = "ExtractSeqs.py INPUT_FOLDER OUTPUT_FILE"

def main(argv):
  try:
    infolder=argv[0]
    outfile=argv[1]
  except IndexError:
    sys.exit(usage)
  

  sequences = []
  for infile in glob(infolder + '/*.fa'):
    if not sequences:
      for seq_record in SeqIO.parse(infile, "fasta"):
        seq_record.id = seq_record.id.split('|')[1]
        seq_record.description = ''
        sequences.append(seq_record)
    else:
      seq_dict = SeqIO.to_dict(SeqIO.parse(infile, "fasta"), key_function=get_species)
      seq_len = len(seq_dict.values()[0])
      for seq in sequences:
        try:
          seq.seq +=seq_dict[seq.id].seq
          del seq_dict[seq.id]
        except KeyError:
          seq.seq += '-' * seq_len
      if len(seq_dict) > 0:
        sys.exit("Error! Sequences for %s are present in %s but not in concatinated alignment" % (join_list(seq_dict.keys()), infile))
    
  SeqIO.write(sequences, outfile, 'fasta')

def get_species(record):
    """"Given a SeqRecord, return the species as a string.
  
    e.g. "jgi|Copci|24" -> "Copci"
    """
    parts = record.id.split("|")
    assert len(parts) == 3 and parts[0] == "jgi" or parts[2] == "kew"
    return parts[1]
    
def join_list(list):
  if isinstance(list, basestring):
    list = [list]
  if len(list) > 1:
    return ', '.join(list[:-1]) + ' and ' + list[-1]
  else:
    return list[0]

if __name__ == "__main__":
   main(sys.argv[1:])
