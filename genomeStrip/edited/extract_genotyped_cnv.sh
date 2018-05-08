## Commands to extract table from full vcf

## Get columns chr, start, end, name, length and genotype per sample
bcftools query -H -f'%CHROM\t%POS0\t%END\t%ID\t%GCLENGTH[\t%CN]\n'  gs_cnv.genotypes.vcf.gz > gs_cnv.reduced.genotypes.txt
