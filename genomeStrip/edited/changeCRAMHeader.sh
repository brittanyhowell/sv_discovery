#!/bin/bash


# bsub -q normal -o /nfs/team151/bh10/scripts/genomestrip_bh10/output/changeCRAMHeader.out -e /nfs/team151/bh10/scripts/genomestrip_bh10/output/changeCRAMHeader.err -R"select[mem>2000] rusage[mem=2000]" -M2000 "/nfs/team151/bh10/scripts/genomestrip_bh10/changeCRAMhead.sh"



cramDIR=/lustre/scratch115/projects/interval_wgs/crams/
wDIR=/lustre/scratch115/projects/interval_wgs/crams/headers/


cd $cramDIR

for CRAM in *.cram  ; do

	filename=${CRAM%.cram}

	echo "editing: "$filename

	outFile=${wDIR}/header_${CRAM}.sam

	samtools view -H $CRAM | sed 's/\*/_/g' > ${outFile}
	samtools reheader -i ${outFile} $CRAM 

done

echo "Complete"
