#!/bin/bash

# bsub -n3  -J "int[1-3642]" -o /nfs/team151/bh10/scripts/bh10_general/output/intersectBD/intersect-%J-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/intersectBD/intersect-%J-%I.err  -R"select[mem>2000] rusage[mem=2000] span[hosts=1]" -M2000 "/nfs/team151/bh10/scripts/bh10_general/run-intersect-genes.sh" 


# outPath - output directory
# geneOut - output file name
# delIn - input deletions list
### Requirements: col1: chr, col2: start, col3: end,
# geneIn - input gene list 	
### Requirements: col1: chr, col2: start, col3: end, col4: name

scriptDIR=/nfs/team151/bh10/scripts/bh10_general/

delInDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642_XY/filtered/

fileList="/nfs/team151/bh10/scripts/bh10_general/fileLists/BD-filtered.list"
files=($(<"${fileList}"))
delIn="${files[$((LSB_JOBINDEX-1))]}" 

# ## Make chromosome 24 also chromosome 23
# subchr="${delIn%.txt}.sub"
# cat ${delInDIR}/${delIn} | awk 'BEGIN {FS="\t"} {if($1 == 24) $1=23;print $0, -F '\t'}'  > ${delInDIR}/${subchr}

# echo "new sub:"
# head -n2 ${delInDIR}/${subchr}


geneIn="/lustre/scratch115/projects/interval_wgs/analysis/gencode/gencode_GRCh38_exons_splice_sites_merged_v26/all_chr_protein_coding.txt"


# Get sample name
samplenoExt=${delIn%.txt}
sampleName=$(echo $samplenoExt | sed 's/BD_filtered_DEL_//g')


outPath="/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/BD/" 
geneOut="${sampleName}_geneList.txt" 




echo "commence intersect for sample ${sampleName}"

echo "Command: go run ${scriptDIR}/intersect_genes.go -outPath ${outPath} -geneOut ${geneOut} -delIn ${delInDIR}/${delIn} -geneIn ${geneIn}"

go run ${scriptDIR}/intersect_genes.go -outPath ${outPath} -geneOut ${geneOut} -delIn ${delInDIR}/${delIn} -geneIn ${geneIn}

# rm ${delInDIR}/${subchr}
echo "complete"

