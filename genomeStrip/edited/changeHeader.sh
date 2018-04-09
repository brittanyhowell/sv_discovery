#!/bin/bash


# bsub -q normal -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/changeBAMHeader.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/changeBAMHeader.err -R"select[mem>2000] rusage[mem=2000]" -M2000 "/nfs/team151/bh10/scripts/breakdancer_bh10/reHeader.sh"



bamDIR=/lustre/scratch115/projects/interval_wgs/WGbams/
echo "bamDIR: "$bamDIR
oDIR=/lustre/scratch115/projects/interval_wgs/WGbams_newheader
echo "oDIR: "$oDIR

cd $bamDIR

for BAM in *.bam  ; do

	filename=${BAM%.bam}

	echo "editing: "$filename

	outFile=${oDIR}/headers/header_${filename}.sam
	echo "outfile: "${outFile}

	samtools view -H $BAM | sed 's/@RGs/RGs/g' > ${outFile}
	samtools reheader ${outFile} $BAM > ${oDIR}/${BAM}

done

echo "Complete"


