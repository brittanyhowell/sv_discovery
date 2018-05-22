#!/bin/bash

# bsub  -o /nfs/team151/bh10/scripts/bh10_general/output/merge-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/merge-%J.err -R"select[mem>10000] rusage[mem=10000]" -M10000 /nfs/team151/bh10/scripts/bh10_general/mergeTab.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/bh10_general/



/software/R-3.4.0/bin/Rscript ${scriptDIR}/merge_intersect_genes.R