#!/bin/bash


#echo 'bash ~/projects/HGDP/scripts/extract_inserts_chr20.sh ${LSB_JOBINDEX}' | bsub -J "bamArray[1-176]" -o /lustre/scratch114/projects/hgdp_wgs/sv/log_files/config/extract_inserts_chr20_sample%I.out


# bsub -J "bamArray[1-226]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/crams/extract_inserts_chr20_sample%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/crams/extract_inserts_chr20_sample%I-%J.err /nfs/team151/bh10/scripts/breakdancer_bh10/extract_inserts_chr20.sh

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



fileDIR=/nfs/team151/bh10/scripts/bh10_general/testDIR
ext=".bam"

oDIR=/nfs/team151/bh10/scripts/bh10_general/testDIR


# Get files with only names
# listFiles=$1
# listFiles=/nfs/team151/bh10/scripts/genomestrip_bh10/fileLists/bamChr20_one_file.list
listFiles=/nfs/team151/bh10/scripts/bh10_general/testDIR/small.list 
files=($(<"${listFiles}"))
# sFile="${files[$((LSB_JOBINDEX-1))]}" 
sFile="${files[$((0))]}" 

echo "Working on: "${sFile}

# # Get the absolute file location.
fFile=${fileDIR}/${sFile}

filename=${sFile%${ext}}


stdFile=${oDIR}/${filename}_std_nohead.sam
stdFile_w_header=${oDIR}/${filename}_std.sam
oFile=${oDIR}/${filename}.std.bam

samtools view -H ${fFile} > ${filename}.header

samtools view ${fFile} | awk '{if($3=="chr1" ||$3=="chr2" ||$3=="chr3" ||$3=="chr4" ||$3=="chr5" ||$3=="chr6" ||$3=="chr7" ||$3=="chr8" ||$3=="chr9" ||$3=="chr10" ||$3=="chr11" ||$3=="chr12" ||$3=="chr13" ||$3=="chr14" ||$3=="chr15" ||$3=="chr16" ||$3=="chr17" ||$3=="chr18" ||$3=="chr19" ||$3=="chr20" ||$3=="chr21" ||$3=="chr22" ||$3=="chrX" ||$3=="chrY" ||$3=="chrM" ) print $0}'| awk '{if($7=="=" || $7=="chr1" ||$7=="chr2" ||$7=="chr7" ||$7=="chr4" ||$7=="chr5" ||$7=="chr6" ||$7=="chr7" ||$7=="chr8" ||$7=="chr9" ||$7=="chr10" ||$7=="chr11" ||$7=="chr12" ||$7=="chr17" ||$7=="chr14" ||$7=="chr15" ||$7=="chr16" ||$7=="chr17" ||$7=="chr18" ||$7=="chr19" ||$7=="chr20" ||$7=="chr21" ||$7=="chr22" ||$7=="chrX" ||$7=="chrY" ||$7=="chrM" ) print $0}' > ${stdFile}

cat ${filename}.header ${stdFile} > ${stdFile_w_header}

samtools view -b ${stdFile_w_header} > ${oFile}











