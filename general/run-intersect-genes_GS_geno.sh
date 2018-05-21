#!/bin/bash

# bsub -J "int[1-226]"  -o /nfs/team151/bh10/scripts/bh10_general/output/intersectGS/geno/intersect-%J-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/intersectGS/geno/intersect-%J-%I.err  -R"select[mem>1000] rusage[mem=1000]" -M1000  "/nfs/team151/bh10/scripts/bh10_general/run-intersect-genes_GS_geno.sh" 


# outPath - output directory
# geneOut - output file name
# delIn - input deletions list
### Requirements: col1: chr, col2: start, col3: end,
# CHROM	POS0	END
# 1	86643	90107
# 1	777429	788739
# 1	785752	788739

# geneIn - input gene list 	
### Requirements: col1: chr, col2: start, col3: end, col4: name

scriptDIR=/nfs/team151/bh10/scripts/bh10_general/

delInDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/filtered_sv/split_tables_CNV_genotyped

fileList="/nfs/team151/bh10/scripts/bh10_general/fileLists/GS-genotyped-SV-filtered.list"
files=($(<"${fileList}"))
delIn="${files[$((LSB_JOBINDEX-1))]}" 


geneIn="/lustre/scratch115/projects/interval_wgs/analysis/gencode/gencode_GRCh38_exons_splice_sites_merged_v26/all_chr_protein_coding.txt"


# Get sample name
samplenoExt=${delIn%.txt}
sampleName=$(echo $samplenoExt | sed 's/GS_filtered_DEL_//g')


outPath="/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/GS-geno/" 
geneOut="${sampleName}_geneList.txt" 




echo "commence intersect for sample ${sampleName}"

go run ${scriptDIR}/intersect_genes.go -outPath ${outPath} -geneOut ${geneOut} -delIn ${delInDIR}/${delIn} -geneIn ${geneIn}

echo "complete"

