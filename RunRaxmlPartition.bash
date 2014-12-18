#!/bin/bash
#
#PBS -l walltime=120:00:00,nodes=1:ppn=16
#

module load apps/RAxML-7.2.8-pthreads
raxml-pthreads -T 16 -f a -m PROTGAMMAWAG -p 12345 -x 12345 -N autoMRE \
    -n ${infile}_partitioned -w Trees \
    -s Phylip/${infile} \
    -p partition.txt

