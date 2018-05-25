#!/bin/bash

#!/bin/bash

# bsub  -o /nfs/team151/bh10/scripts/bh10_general/output/sum_gene-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/sum_gene-%J.err -R"select[mem>1000] rusage[mem=1000]" -M1000 /nfs/team151/bh10/scripts/bh10_general/run-sum_gene_DEL.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/bh10_general/

geneTable="/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/GS-nogeno/disc_geneList.txt"
outTable="/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/merged/exons_with_dels-disc.txt"


/software/R-3.4.0/bin/Rscript ${scriptDIR}/sum_gene_DEL.R ${geneTable} ${outTable}