#!/bin/bash

# bsub -J "BDArray[1-4760]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/indexBAM-%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/indexBAM-%I-%J.err "/nfs/team151/bh10/scripts/breakdancer_bh10/indexBAM.sh /nfs/team151/bh10/scripts/genomestrip_bh10/fileLists/bamList.txt"

fileDIR=/lustre/scratch115/projects/interval_wgs/chr20bams_newHeader/
ext=".bam"

oDIR=/lustre/scratch115/projects/interval_wgs/chr20bams_newHeader/
# listFiles=${oDIR}/fileList.txt

# ## Create file with list of names
# touch ${listFiles}
# cd ${fileDIR}
# ls *${ext} > ${listFiles}

# Get files with only names
listFiles=$1
files=($(<"${listFiles}"))
sFile="${files[$((LSB_JOBINDEX-1))]}" 

echo "Working on: "${sFile}

# # Get the absolute file location.
fFile=${fileDIR}/${sFile}

filename=${sFile%${ext}}

oFile=${oDIR}/${filename}.bam.bai 


    ## Run BD
    echo "samtools index -b ${fFile} > ${oFile}"

    samtools index -b ${fFile} > ${oFile}

# rm ${listFiles}

echo "completed!"