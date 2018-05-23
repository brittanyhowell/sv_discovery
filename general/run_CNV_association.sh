#!/bin/bash

# bsub  -o /nfs/team151/bh10/scripts/bh10_general/output/associate_CNV-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/associate_CNV-%J.err -R"select[mem>1000] rusage[mem=1000]" -M1000 /nfs/team151/bh10/scripts/bh10_general/run-association_CNV.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/bh10_general/


reorderedTable="/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/merged/GS_geno_merge_reorder_association.txt"

echo "running prep"
/software/R-3.4.0/bin/Rscript ${scriptDIR}/prep_association_CNV.R ${reorderedTable}

echo "running association"
/software/R-3.4.0/bin/Rscript ${scriptDIR}/association_CNV.R ${reorderedTable}