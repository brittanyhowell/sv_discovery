#!/bin/bash

# bsub -J "BDArray[1-226]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/o_max_BD-%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/o_max_BD-%I-%J.err "/nfs/team151/bh10/scripts/breakdancer_bh10/BD-run.sh /lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/WGbams_newheader/newBams.txt"

configDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/config/
swDIR=/nfs/users/nfs_k/kw8/software/breakdancer_20130808/breakdancer/
oDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/out/


# Get files with only names
configList=$1
configFiles=($(<"${configList}"))
config="${configFiles[$((LSB_JOBINDEX-1))]}" 

# Get the absolute file location.
configLine=${configDIR}/${config}

filename=${config%.config}

oFile=${oDIR}/${filename}.out


    ## Run BD
	echo "${swDIR}/breakdancer-max -q 20 ${configLine} > ${oFile}"

   ${swDIR}/breakdancer-max -q 20 ${configLine} > ${oFile}