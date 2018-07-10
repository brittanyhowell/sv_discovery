#!/bin/bash

## script links to BD-analyse.R
## BD-analyse takes 7 arguments, listed here. 
## Script set up to run as an array job on the FARM because of large number of files
## Required files: list of filenames with extension ".out"
## Adjust DIRs as needed

# bsub -J "BD-filter[1-3642]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/BD-analyse/BD-analyse-%J-%I.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/BD-analyse/BD-analyse-%J-%I.err -R"select[mem>1000] rusage[mem=1000]" -M1000 /nfs/team151/bh10/scripts/breakdancer_bh10/run-BD_filter.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/breakdancer_bh10/


## Names of the variables in BD--analyse
# args[1] = fileDIR
# args[2] = outDIR
# args[3] = samplenameext
# args[4] = samplename
# args[5] = centromerecoord
# args[6] = gapscoord
# args[7] = moregapscoord


## DIRs
# BD output file DIR
filDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/out/WG_224/
# Where the output tables will go
outDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_224/

## Samples
fileList="/nfs/team151/bh10/scripts/breakdancer_bh10/fileLists/3642_WG_BD_out.list"
samplelist=($(<"${fileList}"))
samplenameext="${samplelist[$((LSB_JOBINDEX-1))]}" 
samplename=${samplenameext%.out}

## Coordinate files
centromerecoord="/nfs/users/nfs_k/kw8/data/genome_info/centromere_GRCh38_combined.txt"
gapscoord="/nfs/users/nfs_k/kw8/data/genome_info/gaps_GRCh38.txt"   
morgapscoord="/nfs/users/nfs_k/kw8/data/genome_info/gaps_human.txt" 

## Run R script with trailing Args
echo "Command: Rscript ${scriptDIR}/BD-filter.R ${filDIR} ${outDIR} ${samplenameext} ${samplename} ${centromerecoord} ${gapscoord} ${morgapscoord}"

/software/R-3.4.0/bin/Rscript ${scriptDIR}/BD-filter.R ${filDIR} ${outDIR} ${samplenameext} ${samplename} ${centromerecoord} ${gapscoord} ${morgapscoord}

echo "complete"

