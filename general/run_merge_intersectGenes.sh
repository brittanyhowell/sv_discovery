#!/bin/bash

# bsub  -o /nfs/team151/bh10/scripts/bh10_general/output/merge-%I.out -e /nfs/team151/bh10/scripts/bh10_general/output/merge-%I.err -R"select[mem>1000] rusage[mem=1000]" -M1000 /nfs/team151/bh10/scripts/bh10_general/mergeTab.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/bh10_general/



/software/R-3.4.0/bin/Rscript ${scriptDIR}/merge_intersect_genes.R