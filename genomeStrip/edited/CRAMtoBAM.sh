#!/bin/bash

# Convert CRAM files in a DIR to BAMs. 

ref=/lustre/scratch115/resources/ref/Homo_sapiens/HS38DH/hs38DH.fa
wDIR=/lustre/scratch115/projects/interval_wgs/crams/
oDIR=/lustre/scratch115/projects/interval_wgs/WGbams/



# bsub -J "cramArray[1-226]" -o /nfs/team151/bh10/scripts/bh10_general/output/CRAM-to-BAM-%I-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/CRAM-to-BAM-%I-%J.err /nfs/team151/bh10/scripts/bh10_general/CRAMtoBAM.sh

# Get files with paths
fcramList=/lustre/scratch115/projects/interval_wgs/crams/listCramFiles.list
cramList=($(<"${fcramList}"))
cramLine="${cramList[$((LSB_JOBINDEX-1))]}"

# Get files with only names
fcramFile=/lustre/scratch115/projects/interval_wgs/crams/listCrams.list
cramFile=($(<"${fcramFile}"))
CRAM="${cramFile[$((LSB_JOBINDEX-1))]}" 

filename=${CRAM%.cram}

echo "working with "$filename

oFile=${oDIR}/${filename}.bam
	
samtools view ${filename}.cram -T ${ref} -b > ${oFile}

echo "complete"





