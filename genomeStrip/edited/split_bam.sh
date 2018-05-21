#!/bin/bash

# Splits bam files up into chromosomes. 


for i in `samtools view -H A.bam | awk -F"\t" '/@SQ/{print $2}' |  cut -d":" -f2`
do
    samtools view -h -F 0x4 -q 10 A.bam $i | samtools view -hbS - > A.$i.bam
done


Split files up per chromosome. 
Run again. 