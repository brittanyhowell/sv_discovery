#!/bin/bash

# bsub -J "BDArray[1-225]" -o /nfs/team151/bh10/scripts/bh10_general/output/indexBAM-%J-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/indexBAM-%J-%I.err "/nfs/team151/bh10/scripts/bh10_general/indexBAM.sh /nfs/team151/bh10/scripts/bh10_general/fileLists/WG_bams.list"

fileDIR=/lustre/scratch115/projects/interval_wgs/WGbams
ext=".bam"

oDIR=/lustre/scratch115/projects/interval_wgs/WGbams
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