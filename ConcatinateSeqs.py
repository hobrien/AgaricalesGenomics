#!/usr/local/bin/python

"""
This will concatinate sequences from alignments based on the second part of their name

"""

import sys, os
from glob import glob
from Bio import SeqIO

usage = "ConcatinateSeqs.py INPUT_FOLDER OUTPUT_FILE"

def main(argv):
  try:
    infolder=argv[0]
    outfile=argv[1]
  except IndexError:
    sys.exit(usage)
  

  sequences = []
  counter = 0
  for infile in glob(infolder + '/*.fa'):
    if '6661' in infile:
      continue  #This is a hack because we've decided to exclude this gene from the combined analysis
    if not sequences:
      for seq_record in SeqIO.parse(infile, "fasta"):
        seq_record.description = ''
        sequences.append(seq_record)
        seq_len = len(seq_record.seq)
    else:
      seq_dict = SeqIO.to_dict(SeqIO.parse(infile, "fasta"))
      seq_len = len(seq_dict.values()[0])
      for seq in sequences:
        try:
          seq.seq +=seq_dict[seq.id].seq
          del seq_dict[seq.id]
        except KeyError:
          seq.seq += '-' * seq_len
      if len(seq_dict) > 0:
        sys.exit("Error! Sequences for %s are present in %s but not in concatinated alignment" % (join_list(seq_dict.keys()), infile))
    print "WAG, %s = %i-%i" % (os.path.basename(infile).split('.')[0], counter + 1, counter+seq_len)
    counter += seq_len
    
  SeqIO.write(sequences, outfile, 'fasta')

    
def join_list(list):
  if isinstance(list, basestring):
    list = [list]
  if len(list) > 1:
    return ', '.join(list[:-1]) + ' and ' + list[-1]
  else:
    return list[0]

if __name__ == "__main__":
   main(sys.argv[1:])
