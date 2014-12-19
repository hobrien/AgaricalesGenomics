#!/bin/bash
#
#PBS -l walltime=12:00:00,nodes=1:ppn=16
#

~/bin/raxml -T 16 -f a -m PROTGAMMAWAG -p 12345 -x 12345 -N autoMRE \
    -n ${infile}_partitioned -w $HOME/Trees \
    -s Phylip/${infile} \
    -q partitions.txt