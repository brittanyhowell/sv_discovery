#!/bin/bash


# bsub -q normal -o /nfs/team151/bh10/scripts/genomestrip_bh10/output/changeBAMHeader.out -e /nfs/team151/bh10/scripts/genomestrip_bh10/output/changeBAMHeader.err -R"select[mem>2000] rusage[mem=2000]" -M2000 "/nfs/team151/bh10/scripts/genomestrip_bh10/reHeader.sh"



bamDIR=/lustre/scratch115/projects/interval_wgs/chr20bams/
oDIR=/lustre/scratch115/projects/interval_wgs/chr20bams_newHeader/

cd $bamDIR

for BAM in *.bam  ; do

	filename=${BAM%.bam}

	echo "editing: "$filename

	outFile=${oDIR}/headers/header_${filename}.sam

	samtools view -H $BAM | sed 's/\*/_/g' > ${outFile}
	samtools reheader ${outFile} $BAM > ${oDIR}/${BAM}

done

echo "Complete"


