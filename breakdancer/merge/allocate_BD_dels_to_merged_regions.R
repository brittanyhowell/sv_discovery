source("~/R_dir/R_scripts/load_nsta_functions.R")

## echo 'R CMD BATCH --vanilla --slave --args --ID=${LSB_JOBINDEX} ~/projects/HGDP/scripts/allocate_BD_dels_to_merged_regions.R' | bsub -J 'chr[1-24]' -R "select[mem>=1000] rusage[mem=1000]" -M1000 -o /lustre/scratch114/projects/hgdp_wgs/sv/log_files/allocate_BD_dels_to_merged_regions/chr%I.out


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
chr <- as.numeric(ID)
print(chr)



##### Which calls fall into each merged region #####

#fn <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/merged_regions/chr",chr,".txt.gz", sep="")
fn <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/merged_regions_basic_filter_80pc/chr",chr,".txt.gz", sep="")
clust <- read.delim(fn, stringsAsFactors=F)
#dels <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/combined/BD_combined_filtered_chr1-22-X-Y.txt.gz", stringsAsFactors=F)       ## 279,587  
dels <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/combined/BD_combined_basic_filter_chr1-22-X-Y.txt.gz", stringsAsFactors=F)    ## 695,615
## get dels by chrom
indchr <- dels[,1]==chr
dels <- dels[indchr,]
## edit libs
dels[,7] <- gsub("\\|[0-9]*", "", dels[,7], perl=TRUE)
ind <- apply(clust, 1, function(v) which(v[2]<=dels[,2] & v[3]>=dels[,2] & v[4]<=dels[,3] & v[5]>=dels[,3]))
## combine info
info <- matrix(0, nrow=nrow(clust), ncol=7)
for (j in 1:7)  {
  info[,j] <- sapply(ind, function(k) paste(as.character(dels[k,j+1]), collapse=",", sep=","))
}
fdat <- data.frame(clust, info)
names(fdat) <- c("chr","startO","startI","endI","endO","starts","ends","size","score","n","lib","RDratio")
#outfile <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/first_filtered_merged/chr",chr,".txt", sep="")
outfile <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/first_filtered_merged_80pc/chr",chr,".txt", sep="")
write.table(fdat, outfile, quote=F, row.names=F, sep="\t")
