#!/bin/bash

scriptDIR=/Users/bh10/Documents/Rotation3/scripts/breakdancer/



# args[1] = fileDIR
# args[2] = outDIR
# args[3] = samplenameext
# args[4] = samplename
# args[5] = centromerecoord
# args[6] = gapscoord
# args[7] = moregapscoord


# DIRs
filDIR="~/Documents/Rotation3/data/BD/WG_full/"
outDIR="~/Documents/Rotation3/data/BD/WG_full/"

# Samples
samplenameext="EGAN00001344523.out" # Change this one to an array name thing
samplename=${samplenameext%.out}

# Coordinate files
centromerecoord="/Users/bh10/Documents/Rotation3/data/hg38/centromere_GRCh38_combined.txt"
gapscoord="/Users/bh10/Documents/Rotation3/data/hg38/gaps_GRCh38.txt"   
morgapscoord="/Users/bh10/Documents/Rotation3/data/hg38/gaps_human.txt" 

# Run R script with trailing Args

Rscript ${scriptDIR}/BD-analyse.R ${filDIR} ${outDIR} ${samplenameext} ${samplename} ${centromerecoord} ${gapscoord} ${morgapscoord}



 
