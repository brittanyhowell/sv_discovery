#!/bin/bash

## script links to GS-filter.R
## GS-filter takes 8 arguments, listed here. 
## Required files: list of filenames with extension ".out"
## Adjust DIRs as needed

# bsub  -o /nfs/team151/bh10/scripts/genomestrip_bh10/output/filter/GS-noGENO-filter-%J.out -e /nfs/team151/bh10/scripts/genomestrip_bh10/output/filter/GSnoGENO--filter-%J.err -R"select[mem>1000] rusage[mem=1000]" -M1000 /nfs/team151/bh10/scripts/genomestrip_bh10/run_GS_nogenotyping-filter.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/genomestrip_bh10/


## Names of the variables in BD--analyse
# args[1] = fileDIR
# args[2] = outDIR
# args[3] = samplenameext
# args[4] = samplename
# args[5] = centromerecoord
# args[6] = gapscoord
# args[7] = moregapscoord
# args[8] = selectedChroms


## DIRs
# GS output file DIR
## required columns: 
# filDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/kw8/genomestrip/genotyping_test/del_output/genotyping/
filDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/kw8/genomestrip/cnv_discovery/cnv_output/results/

# Where the output tables will go
outDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/filtered_sv/

## Samples
samplenameext="gs_cnv.reduced.genotypes.txt"
# samplenameext="gs_dels.sites.reduced.txt"
samplename=${samplenameext%.txt}

## Coordinate files
centromerecoord="/nfs/users/nfs_k/kw8/data/genome_info/centromere_GRCh38_combined.txt"
gapscoord="/nfs/users/nfs_k/kw8/data/genome_info/gaps_GRCh38.txt"   
morgapscoord="/nfs/users/nfs_k/kw8/data/genome_info/gaps_human.txt" 

## Which chromosomes
selectedChroms="autosomes" # When blank, sex chromosomes are included.

## Run R script with trailing Args
echo "Command: Rscript ${scriptDIR}/GS-filter_nogenotyping.R ${filDIR} ${outDIR} ${samplenameext} ${samplename} ${centromerecoord} ${gapscoord} ${morgapscoord} ${selectedChroms}"

/software/R-3.4.0/bin/Rscript ${scriptDIR}/GS_filter_nogenotyping.R ${filDIR} ${outDIR} ${samplenameext} ${samplename} ${centromerecoord} ${gapscoord} ${morgapscoord}

echo "complete"

