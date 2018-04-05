#!/bin/bash

# Convert CRAM files in a DIR to BAMs. 

ref=/lustre/scratch115/resources/ref/Homo_sapiens/HS38DH/hs38DH.fa




# bsub -J "cramArray[1-226]" -o /nfs/team151/bh10/scripts/bh10_general/output/CRAM-to-BAM-%I-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/CRAM-to-BAM-%I-%J.err /nfs/team151/bh10/scripts/bh10_general/CRAMtoBAM.sh


# Get files with only names
fcramFile=/lustre/scratch115/projects/interval_wgs/crams/listCrams.list
cramFile=($(<"${fcramFile}"))
CRAM="${cramFile[$((LSB_JOBINDEX-1))]}" 

# Get the absolute file location.
cramLine=${wDIR}/${CRAM}

filename=${CRAM%.cram}

echo "working with "$filename

oFile=${oDIR}/${filename}.bam
	
samtools view ${cramLine} -T ${ref} -b > ${oFile}

echo "complete"





