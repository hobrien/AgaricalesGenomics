#!/bin/bash
#
#PBS -l walltime=120:00:00,nodes=1:ppn=4
#

module load apps/RAxML-7.2.8-pthreads
raxml-pthreads -T 4 -f a -m PROTGAMMAWAG -p 12345 -x 12345 -N autoMRE \
    -n $infile -w $HOME/Trees \
    -s ${HOME}/Alignments/${infile} \
    #-o Con_pu1,Ser_laS73,Ser_laS79