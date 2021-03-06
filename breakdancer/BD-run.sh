#!/bin/bash

# bsub -J "BDmax[1-3724]" -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/BDmax/max_BD-%I-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/BDmax/max_BD-%I-%J.err "/nfs/team151/bh10/scripts/breakdancer_bh10/BD-run.sh /nfs/team151/bh10/scripts/bh10_general/fileLists/WG_config.list"
# bsub -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/BDmax/max_BD-%J.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/BDmax/max_BD-%J.err "/nfs/team151/bh10/scripts/breakdancer_bh10/BD-run.sh"
 
configDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/config/WG_226/10/
swDIR=/nfs/users/nfs_k/kw8/software/breakdancer_20130808/breakdancer/
oDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/out/10


# Get files with only names
# configList=$1
# configFiles=($(<"${configList}"))
# config="${configFiles[$((LSB_JOBINDEX-1))]}" 
config="10_configs.config"

# Get the absolute file location.
configLine=${configDIR}/${config}

filename=${config%.config}

oFile=${oDIR}/${filename}.out


    ## Run BD
    echo "command"
	echo "${swDIR}/breakdancer-max -q 20 ${configLine} > ${oFile}"

   ${swDIR}/breakdancer-max -q 20 ${configLine} > ${oFile}