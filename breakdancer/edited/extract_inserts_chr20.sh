#!/bin/bash


#echo 'bash ~/projects/HGDP/scripts/extract_inserts_chr20.sh ${LSB_JOBINDEX}' | bsub -J "bamArray[1-176]" -o /lustre/scratch114/projects/hgdp_wgs/sv/log_files/config/extract_inserts_chr20_sample%I.out


# bsub -J "bamArray[1-4760]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/extract_inserts_chr20_sample%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/extract_inserts_chr20_sample%I-%J.err /nfs/team151/bh10/scripts/breakdancer_bh10/extract_inserts_chr20.sh

# bsub -q normal -J "bamArray[1-2]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/-%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/test-%I-%J.err /nfs/team151/bh10/scripts/breakdancer_bh10/test.sh

### SAM/BAM output ###

# 1   QNAME	Query pair NAME if paired; or Query NAME if unpaired
# 2   FLAG	bitwise FLAG
# 3   RNAME	Reference sequence NAME
# 4   POS	1-based leftmost POSition/coordinate of the clipped sequence
# 5   MAPQ	MAPping Quality (phred scaled prob. that the alignment is wrong)
# 6   CIGAR	extended CIGAR string
# 7   MRNM	Mate Reference sequence NaMe; "=" if the same as <RNAME>
# 8   MPOS	1-based leftmost Mate POSition of the clipped sequence
# 9   ISIZE	inferred Insert SIZE
# 10  SEQ	query SEQuence; "=" for a match to the reference; n/N/. for ambiguity; cases are not maintained
# 11  QUA	query QUALity; ASCII-33 gives the Phred base quality
# 12  TAG	TAG
#     VTYPE	Value TYPE
#     VALUE	match <VTYPE>





################## Extract insert sizes from chr20 for 2 samples ################



## Get a list of the file names with file paths
# 
fbamList=/lustre/scratch115/projects/interval_wgs/crams/listCramFiles.list
bamList=($(<"${fbamList}"))
bamLine="${bamList[$((LSB_JOBINDEX-1))]}"


## Generate outfile name
# Input file is list of samples with no filepaths 

fbamFile=/lustre/scratch115/projects/interval_wgs/crams/listCrams.list
bamFile=($(<"${fbamFile}"))
bam="${bamFile[$((LSB_JOBINDEX-1))]}" 

echo "bamLine: ${bamLine}"
echo "bam: "${bam}

filename=${bam%.bam}

echo "filename: "$filename

outfile=/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/${filename}
echo "outfile: "$outfile

     samtools view $bamLine chr20:10000000-11000000 | awk -F '\t' '$5>20 && $9>=0' | cut -f9 | gzip -f > ${outfile}_20.gz






