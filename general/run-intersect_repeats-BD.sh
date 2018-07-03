#!/bin/bash

# bsub  -J "int[1-224]" -o /nfs/team151/bh10/scripts/bh10_general/output/intersectBD/intersect_rep-%J-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/intersectBD/intersect_rep-%J-%I.err  -R"select[mem>2000] rusage[mem=2000] span[hosts=1]" -M2000 "/nfs/team151/bh10/scripts/bh10_general/run-intersect_repeats-BD.sh" 

# Job <2272421> is submitted to default queue <normal>.



# outPath - output directory
# repeatOut - output file name
# delIn - input deletions list
### Requirements: col1: chr, col2: start, col3: end,
# repeatIn - input repeat list 	
### Requirements: col1: chr, col2: start, col3: end, col4: class, col5: family.

scriptDIR=/nfs/team151/bh10/scripts/bh10_general/
b
delInDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642_XY/226subset/

fileList="/nfs/team151/bh10/scripts/bh10_general/fileLists/BD-filtered.list"
files=($(<"${fileList}"))
delIn="${files[$((LSB_JOBINDEX-1))]}" 




repeatIn="/lustre/scratch115/projects/interval_wgs/analysis/gatk/Homo_sapiens_assembly38/ucsc_repeats_GRCh38_chroms1-22-X-Y-M.bed"


# Get sample name
samplenoExt=${delIn%.txt}
sampleName=$(echo $samplenoExt | sed 's/BD_filtered_DEL_//g')


outPath="/lustre/scratch115/projects/interval_wgs/analysis/sv/repeatIntersect/BD/" 
repeatOut="${sampleName}_BD_repeat_ann.txt" 




echo "commence intersect for sample ${sampleName}"

echo "Command: go run ${scriptDIR}/intersect_genes.go -outPath ${outPath} -repeatOut ${repeatOut} -delIn ${delInDIR}/${delIn} -repeatIn ${repeatIn}"

go run ${scriptDIR}/intersect_repeats.go -outPath ${outPath} -repeatOut ${repeatOut} -delIn ${delInDIR}/${delIn} -repeatIn ${repeatIn}

# rm ${delInDIR}/${subchr}
echo "complete"

