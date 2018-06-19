## Commands to extract table from full vcf


# Output was in: 
# /lustre/scratch115/projects/interval_wgs/analysis/sv/kw8/genomestrip/cnv_discovery/cnv_output/results/
## Get columns chr, start, end, name, length and genotype per sample
bcftools query -H -f'%CHROM\t%POS0\t%END\t%ID\t%GCLENGTH[\t%CN]\n'  gs_cnv.genotypes.vcf.gz > gs_cnv.reduced.genotypes.txt


## Not CNV, but disc:
bcftools query -H -f'%CHROM\t%POS\t%INFO/END\t%ID\t%FILTER\n'  gs_dels.sites.vcf > gs_dels.sites.reduced.txt

## For the discovery files that are genotyped

# FileA: 
bcftools query -H -f'%CHROM\t%POS0\t%END\t%ID\t%GSELENGTH[\t%GT]\n' gs_dels.genotypes.vcf.gz > gs_dels.genotypes.reduced.txt

# FileB: 
bcftools query -H -f'[\t%GT]\n' gs_dels.genotypes.vcf.gz > gs_dels.just.genotypes.reduced.txt

# Paste together: 
paste /lustre/scratch115/projects/interval_wgs/analysis/sv/kw8/genomestrip/genotyping_test2/del_output/genotyping/gs_dels.genotypes.reduced.2.txt gs_dels.just.genotypes.reduced.txt > /lustre/scratch115/projects/interval_wgs/analysis/sv/kw8/genomestrip/discovery/226_discovery_genotypes.txt
