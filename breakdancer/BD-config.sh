#!/bin/bash

# bsub -J "BDArray[1-4]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/BD-%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/BD-%I-%J.err "/nfs/team151/bh10/scripts/breakdancer_bh10/runBD.sh /nfs/team151/bh10/scripts/breakdancer_bh10/fourBams.list"

fileDIR=/lustre/scratch115/projects/interval_wgs/chr20bams/
ext=".bam"

swDIR=/nfs/users/nfs_k/kw8/software/breakdancer_20130808/breakdancer/
oDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/config/
listFiles=${oDIR}/fileList.txt

## Create file with list of names
touch ${listFiles}
cd ${fileDIR}
ls *${ext} > ${listFiles}

# Get files with only names
files=($(<"${listFiles}"))
sFile="${files[$((LSB_JOBINDEX-1))]}" 

echo "Working on: "${sFile}

# # Get the absolute file location.
fFile=${fileDIR}/${sFile}

filename=${sFile%${ext}}

oFile=${oDIR}/${filename}.config


    ## Run BD
    echo "perl ${swDIR}/bam2cfg.pl -c 4 -q 20 -n 10000 ${bamLine} > ${oFile}"

    perl ${swDIR}/bam2cfg.pl -c 4 -q 20 -n 10000 ${fFile} > ${oFile}

rm ${listFiles}

echo "completed!"