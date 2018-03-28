#!/bin/bash


# bsub -q normal -o /lustre/scratch115/projects/interval_wgs/testFile/changeCRAMHeader.out -e /lustre/scratch115/projects/interval_wgs/testFile/changeCRAMHeader.err -R"select[mem>2000] rusage[mem=2000]" -M2000 "/lustre/scratch115/projects/interval_wgs/testFile/changeCRAMhead.sh"



cramDIR=/lustre/scratch115/projects/interval_wgs/testFile/testBAM
wDIR=/lustre/scratch115/projects/interval_wgs/testFile/headers


cd $cramDIR

for CRAM in *.cram  ; do

	filename=${CRAM%.cram}

	echo "editing: "$filename

	outFile=${wDIR}/header_${CRAM}.sam

	samtools view -H $CRAM | sed 's/\*/_/g' > ${outFile}
	samtools reheader -i ${outFile} $CRAM 

done

echo "Complete"


