## Commands to extract table from full vcf


# Output was in: 
# /lustre/scratch115/projects/interval_wgs/analysis/sv/kw8/genomestrip/cnv_discovery/cnv_output/results
## Get columns chr, start, end, name, length and genotype per sample
bcftools query -H -f'%CHROM\t%POS0\t%END\t%ID\t%GCLENGTH[\t%CN]\n'  gs_cnv.genotypes.vcf.gz > gs_cnv.reduced.genotypes.txt
