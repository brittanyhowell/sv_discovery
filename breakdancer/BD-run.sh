#!/bin/bash

# bsub -J "BDArray[1-4]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/BDHH-%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/BDHH-%I-%J.err "/nfs/team151/bh10/scripts/breakdancer_bh10/runBD.sh /lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/config/config.list"

configDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/config/
swDIR=/nfs/users/nfs_k/kw8/software/breakdancer_20130808/breakdancer/
oDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/real


# Get files with only names
bamList=$1
bamFiles=($(<"${bamList}"))
BAM="${bamFiles[$((LSB_JOBINDEX-1))]}" 

# Get the absolute file location.
bamLine=${configDIR}/${BAM}

filename=${BAM%.config}

oFile=${oDIR}/${filename}.BD


    ## Run BD

    ### Make config files 
    # echo "perl ${swDIR}/bam2cfg.pl -c 4 -q 20 -n 10000 ${bamLine} > ${oFile}"

    # perl ${swDIR}/bam2cfg.pl -c 4 -q 20 -n 10000 ${bamLine} > ${oFile}



   ${swDIR}/breakdancer-max -q 20 ${bamLine} > ${oFile}