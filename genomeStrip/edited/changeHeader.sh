#!/bin/bash


# bsub -q normal -o /lustre/scratch115/projects/interval_wgs/testFile/changeHeader.out -e /lustre/scratch115/projects/interval_wgs/testFile/changeHeader.err -R"select[mem>2000] rusage[mem=2000]" -M2000 "/lustre/scratch115/projects/interval_wgs/testFile/testReHeader.sh"



bamDIR=/lustre/scratch115/projects/interval_wgs/testFile/testBam
wDIR=/lustre/scratch115/projects/interval_wgs/testFile/headers


cd $bamDIR

for BAM in *.bam  ; do

	filename=${BAM%.bam}

	echo "editing: "$filename

	outFile=${wDIR}/header_${BAM}

	# samtools view -H ${BAM} | wc -l 
	samtools view -H $BAM | sed 's/\*/_/g' > ${outFile}
	samtools reheader ${outFile} $BAM > n_${BAM}
	rm ${BAM}
	mv ${n_BAM} ${BAM}



done

echo "Complete"


