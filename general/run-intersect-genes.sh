#!/bin/bash

# outPath - output directory
# geneOut - output file name
# delIn - input deletions list
### Requirements: col1: chr, col2: start, col3: end,
# geneIn - input gene list 	
### Requirements: col1: chr, col2: start, col3: end, col4: name

scriptDIR=/nfs/team151/bh10/scripts/bh10_general/

delInDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642_XY/filtered/
delIn="BD_filtered_DEL_EGAN00001362099.txt" 
geneIn="/lustre/scratch115/projects/interval_wgs/analysis/gencode/gencode_GRCh38_exons_splice_sites_merged_v26/all_chr_protein_coding.txt"


# Get sample name
samplenoExt=${delIn%.txt}
sampleName=$(echo $samplenoExt | sed 's/BD_filtered_DEL_//g')


outPath="/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/BD/" 
geneOut="${sampleName}_geneList.txt" 




echo "commence intersect"

go run ${scriptDIR}/intersect_genes.go -outPath ${outPath} -geneOut ${geneOut} -delIn ${delInDIR}/${delIn} -geneIn ${geneIn}

echo "complete"

