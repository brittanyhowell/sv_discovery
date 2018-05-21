#!/bin/bash

# bsub  -o /nfs/team151/bh10/scripts/bh10_general/output/merge-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/merge-%J.err -R"select[mem>4000] rusage[mem=4000]" -M4000 /nfs/team151/bh10/scripts/bh10_general/mergeTab.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/bh10_general/



/software/R-3.4.0/bin/Rscript ${scriptDIR}/merge_intersect_genes.R