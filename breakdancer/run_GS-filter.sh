#!/bin/bash

## script links to GS-filter.R
## GS-filter takes 7 arguments, listed here. 
## Script set up to run as an array job on the FARM because of large number of files
## Required files: list of filenames with extension ".out"
## Adjust DIRs as needed

# bsub  -o /nfs/team151/bh10/scripts/genomestrip_bh10/output/filter/GS-filter-%J.out -e /nfs/team151/bh10/scripts/genomestrip_bh10/output/filter/GS-filter-%J.err -R"select[mem>1000] rusage[mem=1000]" -M1000 /nfs/team151/bh10/scripts/genomestrip_bh10/run_GS-filter.sh

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


## DIRs
# GS output file DIR
filDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/kw8/genomestrip/cnv_discovery/cnv_output/results/
# Where the output tables will go
outDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642/

## Samples
samplenameext="gs_cnv.genotypes.vcf.gz"
samplename=${samplenameext%.vcf.gz}

## Coordinate files
centromerecoord="/nfs/users/nfs_k/kw8/data/genome_info/centromere_GRCh38_combined.txt"
gapscoord="/nfs/users/nfs_k/kw8/data/genome_info/gaps_GRCh38.txt"   
morgapscoord="/nfs/users/nfs_k/kw8/data/genome_info/gaps_human.txt" 

## Run R script with trailing Args
echo "Command: Rscript ${scriptDIR}/BD-filter.R ${filDIR} ${outDIR} ${samplenameext} ${samplename} ${centromerecoord} ${gapscoord} ${morgapscoord}"

/software/R-3.4.0/bin/Rscript ${scriptDIR}/BD-filter.R ${filDIR} ${outDIR} ${samplenameext} ${samplename} ${centromerecoord} ${gapscoord} ${morgapscoord}

echo "complete"

