#!/bin/bash

## Script exists to grab 226 matching dataframes from the BD pool

fileFile=/nfs/team151/bh10/scripts/genomestrip_bh10/fileLists/subset_GS.list

BDDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642_XY/filtered/
outDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/226subset/



while read p; do

	sample=$(echo ${p} | awk  -F'[_]' '{print $2}' )
 



 	BDFile="BD_filtered_DEL_${sample}.txt"
 	BDLoc=${BDDIR}/${BDFile}
 
 echo "moving: ${BDLoc} TO  ${outDIR}"
 	mv ${BDLoc} ${outDIR}

done <${fileFile}


## EGAN00001362048_geneList.txt - not in BD
## EGAN00001362048_geneList.txt - not in BD

