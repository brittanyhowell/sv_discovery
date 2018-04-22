#!/bin/bash

# bsub -J "BDArray[1-226]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/con_BD-%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/con_BD-%I-%J.err "/nfs/team151/bh10/scripts/breakdancer_bh10/config_BD.sh /nfs/team151/bh10/scripts/breakdancer_bh10/WGbams.list"

fileDIR=/lustre/scratch115/projects/interval_wgs/WGbams_std
ext=".bam"

swDIR=/nfs/users/nfs_k/kw8/software/breakdancer_20130808/breakdancer/
oDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/config_std/


# Get files with only names
listFiles=$1
files=($(<"${listFiles}"))
sFile="${files[$((LSB_JOBINDEX-1))]}" 

echo "Working on: "${sFile}

# # Get the absolute file location.
fFile=${fileDIR}/${sFile}

filename=${sFile%${ext}}

oFile=${oDIR}/${filename}.config


    ## Run BD
    echo "perl swdir: ${swDIR}/bam2cfg.pl -c 4 -q 20 -n 10000 bamLine: ${bamLine} > oFile: ${oFile}"

    perl ${swDIR}/bam2cfg.pl -c 4 -q 20 -n 10000 ${fFile} > ${oFile}


echo "completed!"