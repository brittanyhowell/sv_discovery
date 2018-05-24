#!/bin/bash

# bsub  -o /nfs/team151/bh10/scripts/bh10_general/output/intersects/intersect-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/intersects/intersect-%J.err -R"select[mem>1000] rusage[mem=1000]" -M1000 /nfs/team151/bh10/scripts/bh10_general/run-recip_intersect.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/bh10_general/



fileA="/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/filtered_sv/GS_filtered_DEL_CNV_no_genotype_info.txt" 
fileA_type="GS_disc"
fileB="/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642_XY/BD_filtered_DEL_224_sorted.txt"
fileB_type="BD"
outDIR="/lustre/scratch115/projects/interval_wgs/analysis/sv/intersects/"
out="intersect_${fileA_type}_${fileB_type}.txt"


echo "run intersect for ${fileA_type} and ${fileB_type}"

echo "command:  go run ${scriptDIR}/recip_intersect.go -oneIn=${fileA} -twoIn=${fileB} -outPath=${outDIR} -out=${out}"
go run ${scriptDIR}/recip_intersect.go -oneIn=${fileA} -twoIn=${fileB} -outPath=${outDIR} -out=${out}

echo "complete"
