#!/bin/bash
#
#PBS -l walltime=12:00:00,nodes=1:ppn=4
#

~/bin/raxml -T 4 -f a -m PROTGAMMAWAG -p 12345 -x 12345 -N autoMRE \
    -n $infile -w $HOME/Trees \
    -s Phylip/${infile} 