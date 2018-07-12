#!/bin/bash

# bsub -J "index[1-10]" -o /nfs/team151/bh10/scripts/bh10_general/output/indexBAM-%J-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/indexBAM-%J-%I.err "/nfs/team151/bh10/scripts/bh10_general/indexBAM.sh /nfs/team151/bh10/scripts/bh10_general/fileLists/10Bams.list"

# Job <4173612> is submitted to default queue <normal>. - 11 July

fileDIR=/lustre/scratch115/projects/interval_wgs/testBams
ext=".bam"

oDIR=/lustre/scratch115/projects/interval_wgs/testBams
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

    /software/hgi/pkglocal/samtools-1.3.1/bin/samtools index -b ${fFile} > ${oFile}

# rm ${listFiles}

echo "completed!"