source("~/R_dir/R_scripts/load_nsta_functions.R")



##### Convert to VCF format for deletion sites #####

vcf.header <- c(
'##fileformat=VCFv4.1',
'##fileDate=20160603',
'##source=BreakDancerMax-1.1.2',
'##reference=GRCh38',
'##ALT=<ID=DEL,Description="Deletion">',
'##INFO=<ID=CIEND,Number=2,Type=Integer,Description="Confidence interval around END for imprecise variants">',
'##INFO=<ID=CIPOS,Number=2,Type=Integer,Description="Confidence interval around POS for imprecise variants">',
'##INFO=<ID=END,Number=1,Type=Integer,Description="End coordinate of this variant">',
'##INFO=<ID=IMPRECISE,Number=0,Type=Flag,Description="Imprecise structural variation">',
'##INFO=<ID=SVLEN,Number=.,Type=Integer,Description="Difference in length between REF and ALT alleles">',
'##INFO=<ID=SVMETHOD,Number=.,Type=String,Description="Type of approach used to detect SV: RP (read pair), RD (read depth), SR (split read), or AS (assembly)">',
'##INFO=<ID=SVTYPE,Number=1,Type=String,Description="Type of structural variant">',
'##INFO=<ID=SAMPLES,Number=.,Type=String,Description="Samples contributing discrepant read pairs">',
'##INFO=<ID=READGROUPS,Number=.,Type=String,Description="Read groups contributing discrepant read pairs">',
'##FILTER=<ID=q10,Description="Quality below 10">')
f <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/call_sets/combined_dels.txt.gz", stringsAsFactors=F)    ## 2620
s <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_thresh_by_sample.txt", stringsAsFactors=F)          ##  176
nf <- matrix(".", nrow=nrow(f), ncol=8)
nf[,1] <- f[,1]
nf[,2] <- f[,2]
nf[,3] <- paste("SI_BD",1:nrow(nf),sep="_")
nf[,4] <- "N"
nf[,5] <- "<DEL>"
## INFO field
ed <- f[,3]
ed <- paste("END", ed, sep="=")
cipos1 <- f[,4] - f[,2]
cipos2 <- f[,5] - f[,2]
indp <- cipos1 >= -50
cipos1[indp] <- -50
indp <- cipos2 <= 50
cipos2[indp] <- 50
cipos <- paste("CIPOS=",cipos1,",",cipos2, sep="")
ciend1 <- f[,6] - f[,3]
ciend2 <- f[,7] - f[,3]
indp <- ciend1 >= -50
ciend1[indp] <- -50
indp <- ciend2 <= 50
ciend2[indp] <- 50
ciend <- paste("CIEND=",ciend1,",",ciend2, sep="")
svlen <- -as.vector(sapply(f$size, function(v) round(mean(as.numeric(unlist(strsplit(v, ",")))))))
svlen <- paste("SVLEN", svlen, sep="=")
rgs <- lapply(f$lib, function(v) unlist(strsplit(v, ",")))
rgs <- lapply(rgs, function(v) unlist(strsplit(v, "\\:")))
rgs <- lapply(rgs, function(v) gsub("\\|[0-9]*", "", v, perl=TRUE))
rgs <- sapply(rgs, paste, collapse=",")
rgs <- paste("SAMPLES", rgs, sep="=")
imprecise <- rep("IMPRECISE", nrow(f))
svtype <- rep("SVTYPE=DEL", nrow(f))
svmethod <- rep("SVMETHOD=RP", nrow(f))
info <- data.frame(ed, cipos, ciend, imprecise, svlen, svtype, svmethod, rgs)
info <- apply(info, 1, paste, collapse=";")
nf[,8] <- info
nf <- apply(nf, 1, paste, collapse="\t")
h <- "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO"
nf <- c(vcf.header, h, nf)
nfn <- "/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/call_sets/BD.dels.sites.20160603.vcf"
write(nf, nfn)



##### Convert to VCF format for deletion genotypes #####

vcf.header <- c(
'##fileformat=VCFv4.1',
'##fileDate=20160603',
'##source=BreakDancerMax-1.1.2',
'##reference=GRCh38',
'##ALT=<ID=DEL,Description="Deletion">',
'##INFO=<ID=CIEND,Number=2,Type=Integer,Description="Confidence interval around END for imprecise variants">',
'##INFO=<ID=CIPOS,Number=2,Type=Integer,Description="Confidence interval around POS for imprecise variants">',
'##INFO=<ID=END,Number=1,Type=Integer,Description="End coordinate of this variant">',
'##INFO=<ID=IMPRECISE,Number=0,Type=Flag,Description="Imprecise structural variation">',
'##INFO=<ID=SVLEN,Number=.,Type=Integer,Description="Difference in length between REF and ALT alleles">',
'##INFO=<ID=SVMETHOD,Number=.,Type=String,Description="Type of approach used to detect SV: RP (read pair), RD (read depth), SR (split read), or AS (assembly)">',
'##INFO=<ID=SVTYPE,Number=1,Type=String,Description="Type of structural variant">',
'##INFO=<ID=SAMPLES,Number=.,Type=String,Description="Samples contributing discrepant read pairs">',
'##INFO=<ID=READGROUPS,Number=.,Type=String,Description="Read groups contributing discrepant read pairs">',
'##FILTER=<ID=q10,Description="Quality below 10">',
'##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">')
f <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/call_sets/combined_dels.txt.gz", stringsAsFactors=F)    ## 2620
s <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_thresh_by_sample.txt", stringsAsFactors=F)          ##  176
## get samples
samples <- sort(unique(s$ID))   
## fill first 5 fields
nf <- matrix(".", nrow=nrow(f), ncol=8)
nf[,1] <- f[,1]
nf[,2] <- f[,2]
nf[,3] <- paste("SI_BD",1:nrow(nf),sep="_")
nf[,4] <- "N"
nf[,5] <- "<DEL>"
## fill in INFO field
ed <- f[,3]
ed <- paste("END", ed, sep="=")
cipos1 <- f[,4] - f[,2]
cipos2 <- f[,5] - f[,2]
indp <- cipos1 >= -50
cipos1[indp] <- -50
indp <- cipos2 <= 50
cipos2[indp] <- 50
cipos <- paste("CIPOS=",cipos1,",",cipos2, sep="")
ciend1 <- f[,6] - f[,3]
ciend2 <- f[,7] - f[,3]
indp <- ciend1 >= -50
ciend1[indp] <- -50
indp <- ciend2 <= 50
ciend2[indp] <- 50
ciend <- paste("CIEND=",ciend1,",",ciend2, sep="")
svlen <- -as.vector(sapply(f$size, function(v) round(mean(as.numeric(unlist(strsplit(v, ",")))))))
svlen <- paste("SVLEN", svlen, sep="=")
rgs <- lapply(f$lib, function(v) unlist(strsplit(v, ",")))
rgs <- lapply(rgs, function(v) unlist(strsplit(v, "\\:")))
## fill in genotypes
gts <- matrix("0/0", nrow=nrow(f), ncol=length(samples))
colnames(gts) <- samples
for (i in 1:nrow(gts))  {
  gts[i,rgs[[i]]] <- "0/1"
}
gts <- apply(gts, 1, paste, collapse="\t")
## fill in INFO field
rgs <- sapply(rgs, paste, collapse=",")
rgs <- paste("SAMPLES", rgs, sep="=")
imprecise <- rep("IMPRECISE", nrow(f))
svtype <- rep("SVTYPE=DEL", nrow(f))
svmethod <- rep("SVMETHOD=RP", nrow(f))
info <- data.frame(ed, cipos, ciend, imprecise, svlen, svtype, svmethod, rgs)
info <- apply(info, 1, paste, collapse=";")
nf[,8] <- info
nf <- apply(nf, 1, paste, collapse="\t")
fdat <- paste(nf, gts, sep="\tGT\t")
## header
ssamples <- paste(samples, collapse="\t")
h <- paste("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT", ssamples, sep="\t")
fdat <- c(vcf.header, h, fdat)
nfn <- "/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/call_sets/BD.dels.gts.20160603.vcf"
write(fdat, nfn)


