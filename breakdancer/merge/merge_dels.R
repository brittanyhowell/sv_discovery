source("~/R_dir/R_scripts/load_nsta_functions.R")

## echo 'R CMD BATCH --vanilla --slave --args --ID=${LSB_JOBINDEX} ~/projects/HGDP/scripts/merge_dels.R' | bsub -J 'chr[1-24]' -R "select[mem>=10000] rusage[mem=10000]" -M10000 -o /lustre/scratch114/projects/hgdp_wgs/sv/log_files/merge_dels/chr%I.out 


get.Args <- function() {
   ## Extract argument names and corresponding values
   my_args_list   <- strsplit(grep("=", gsub("--", "", commandArgs()), value = T), "=")
   my_args        <- lapply(my_args_list, function(x) x[2])
   names(my_args) <- lapply(my_args_list, function(x) x[1])
   ## Assign argument values to global variables in R
   for (arg_name in names(my_args)) {
     eval(parse(text=paste(arg_name, " <<- my_args[[arg_name]]", 
sep="")))
   }
}
## ID is the global parameter from ${LSB_JOBINDEX} which is 1-24 which refers to the chr
get.Args()
i <- as.numeric(ID)
print(i)


##### Create regions of interest #####

centro <- read.delim("/nfs/users/nfs_k/kw8/data/genome_info/centromere_GRCh38_combined.txt", stringsAsFactors=F, header=F)
dels <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/combined/BD_combined_filtered_chr1-22-X-Y.txt.gz", stringsAsFactors=F)   ## 279,587
## get chromosome for deletions
indchr <- dels[,1]==i
dels <- dels[indchr,1:3]
## get chromosome for centromere 
indchr <- centro[,1]==i
centro <- centro[indchr,]
## dels in chrom arms
pdat <- dels[which(dels[,2] <= as.vector(as.matrix(centro[2]))),]
qdat <- dels[which(dels[,2] > as.vector(as.matrix(centro[3]))),]
## cluster blocks for p-arm
if (nrow(pdat)!=0)  {
  dpos <- get.blocks(pdat)
  cluster <- cluster.blocks(dpos)  
  pclust <- merge.cluster.blocks(dpos, cluster, thresh=0.5)
}  else  {
  pclust <- pdat
}   
## cluster blocks for q-arm
if (nrow(qdat)!=0)  {
  dpos <- get.blocks(qdat)
  cluster <- cluster.blocks(dpos)
  qclust <- merge.cluster.blocks(dpos, cluster, thresh=0.5)
}  else  {
  qclust <- qdat
} 
## combine p-arm and q-arm
fclust <- data.frame(rbind(pclust, qclust), stringsAsFactors=F)
names(fclust) <- c("chr","startO","startI","endI","endO")
## order regions
ord <- order(fclust$chr, fclust$startO)
fclust <- fclust[ord,]
## save
fn <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/merged_regions/chr",i,".txt", sep="")
write.table(fclust, fn, quote=F, row.names=F, sep="\t")

