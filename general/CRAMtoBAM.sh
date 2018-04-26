#!/bin/bash

# Convert CRAM files in a DIR to BAMs. 




# bsub -J "cramArray[1-3724]" -o /nfs/team151/bh10/scripts/bh10_general/output/CRAMtoBAM/CRAM-to-BAM-%J-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/CRAMtoBAM/CRAM-to-BAM-%J-%I.err /nfs/team151/bh10/scripts/bh10_general/CRAMtoBAM.sh



ref=/lustre/scratch115/resources/ref/Homo_sapiens/HS38DH/hs38DH.fa
wDIR=/lustre/scratch115/projects/interval_wgs/crams/
oDIR=/lustre/scratch115/projects/interval_wgs/WGbams/


# ## Check that oDIR exists, if not, create. 
# 	if [ -d $oDIR ]; then
# 		rm -r $oDIR 
# 		mkdir $oDIR
# 		echo "OUT folder exists... replacing"  
# 		echo $oDIR 
# 	else 
# 		echo "creating OUT folder:" 
# 		echo $oDIR 
# 		mkdir $oDIR
# 	fi 

# ## Check that referece exists, if not, escape
# 	if [ -f $ref ]; then
# 		echo "using ref seq at $ref "
# 	else 
# 		echo "PROVIDE A REF YOU TOAST"
# 		exit
# 	fi 	




# Get files with only names
fcramFile=/nfs/team151/bh10/scripts/bh10_general/fileLists/WG_crams.list
cramFile=($(<"${fcramFile}"))
CRAM="${cramFile[$((LSB_JOBINDEX-1))]}" 

# Get the absolute file location.
cramLine=${wDIR}/${CRAM}

filename=${CRAM%.cram}

echo "working with "$filename

oFile=${oDIR}/${filename}.bam
samtools view ${cramLine} -T ${ref} -b > ${oFile}

echo "complete"






