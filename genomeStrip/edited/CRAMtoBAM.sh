#!/bin/bash

# Convert CRAM files in a DIR to BAMs. 

ref=/lustre/scratch115/resources/ref/Homo_sapiens/HS38DH/hs38DH.fa

for CRAM in *.cram ; do

	filename=${CRAM%.cram}

	samtools view ${filename}.cram -T ${ref} -b ${filename}.bam

done