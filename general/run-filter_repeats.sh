#!/bin/bash

# bsub -J "int[1-226]"  -o /nfs/team151/bh10/scripts/bh10_general/output/repeatFilter/repFilt-%J-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/repeatFilter/repFilt-%J-%I.err  -R"select[mem>1000] rusage[mem=1000]" -M1000  "/nfs/team151/bh10/scripts/bh10_general/run-filter_repeats.sh" 

# bsub  -o /nfs/team151/bh10/scripts/bh10_general/output/repeatFilter/repFilt-%J-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/repeatFilter/repFilt-%J-%I.err  -R"select[mem>3000] rusage[mem=3000]" -M3000  "/nfs/team151/bh10/scripts/bh10_general/run-filter_repeats-BD.sh" 

# outPath - output directory
# filtOut - output file name
# delIn - input deletions list
### Requirements: col1: chr, col2: start, col3: end,
# CHROM	POS0	END
# 1	86643	90107
# 1	777429	788739
# 1	785752	788739

# repIn - input repeat list 	
### Requirements: col1: chr, col2: start, col3: end, col4: name

scriptDIR=/nfs/team151/bh10/scripts/bh10_general/

delInDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642_XY

# fileList="/nfs/team151/bh10/scripts/bh10_general/fileLists/GS-genotyped-SV-filtered.list"
# files=($(<"${fileList}"))
# delIn="${files[$((LSB_JOBINDEX-1))]}" 
# delIn="GS_filtered_DEL_disc.txt"
# delIn="GS_filtered_DEL_CNV.txt"
delIn="BD_filtered_DEL_224.txt"


repIn="/lustre/scratch115/projects/interval_wgs/analysis/gatk/Homo_sapiens_assembly38/ucsc_repeats_GRCh38.txt.gz"


# Get sample name
samplenoExt=${delIn%.txt}
sampleName=$(echo $samplenoExt | sed 's/GS_filtered_DEL_//g'  | sed 's/BD_filtered_DEL_//g')


outPath="/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/filtered_sv" 
filtOut="${sampleName}_norepeats.txt" 




echo "commence repeat purging for sample ${sampleName}"
echo "command: "

/software/R-3.4.0/bin/Rscript ${scriptDIR}/filter_repeats.R ${repIn} ${delInDIR} ${outPath} ${delIn} ${sampleName} ${outPath}/${filtOut}

echo "complete"

