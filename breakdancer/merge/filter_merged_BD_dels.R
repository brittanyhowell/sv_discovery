source("~/R_dir/R_scripts/load_nsta_functions.R")



##### Filter merged calls by deletion size and confidence interval size #####

## loop through chroms
for (chr in 1:24)  {
  print(chr)
  #infile <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/first_filtered_merged/chr",chr,".txt.gz", sep="")
  infile <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/first_filtered_merged_80pc/chr",chr,".txt.gz", sep="")
  f <- read.delim(infile, stringsAsFactors=F)
  s <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_thresh_by_sample.txt", stringsAsFactors=F)   ## 176
  ## per lib average detectable deletion length
  thresh <- s$MaxThresh - s$Median
  dat <- data.frame(s$ID, thresh)
  ## get minimum threshold for samples; for the samples that support the deletion get an average deletion length cut-off for each site
  samplelist <- vecstr2liststr(f$lib, ",")
  inds <- sapply(samplelist, function(v) sapply(v, function(w) which(w==s$ID)))
  fthresh <- as.vector(unlist(sapply(inds, function(v) median(thresh[unlist(v)], na.rm=TRUE))))    ## changed from max to median 2011-04-28
  ## get min del size estimates for combined libs
  size <- vecstr2liststr(f$size, ",")
  minsize <- sapply(size, function(v) min(as.numeric(v)))
  maxsize <- sapply(size, function(v) max(as.numeric(v)))
  ## filter by deletion size
  indds <- minsize > fthresh
  ## filter for great discrepancy in deletion size estimates
  varsize <- sapply(size, function(v) max(as.numeric(v)) - min(as.numeric(v)))
  inddi <- varsize < 2*fthresh
  ## filter for great discrepancy between deletion size estimates and inner confidence limits
  innersize <- f[,4] - f[,3]
  indie <- abs(innersize - minsize) < 2*fthresh
  ## filter inner breakpoint distance
  indin <- (f$endI - f$startI) > fthresh
  ## filter by confidence interval
  indco <- (f$startI - f$startO) < 2*fthresh & (f$endO - f$endI) < 2*fthresh
  ## filter if outer confidence interval is less than the maximal estimated  size
  outersize <- (f$endO - f$startO)
  indout <- outersize >= maxsize
  ## filter for read depth
  rdlist <- vecstr2liststr(f$RDratio, ",")
  rd <- sapply(rdlist, function(v) round(mean(as.numeric(v),na.rm=T),4))
  indrd <- rd < 0.75 & !is.na(rd)
  ## combine all filters
  indff <- which(indds & inddi & indie & indin & indco & indout & indrd)
  fdat <- f[indff,]
  ## save deletions
  #outfile <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/first_filtered_merged_filtered/chr",chr,".txt", sep="")
  outfile <- paste("/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/first_filtered_merged_filtered_80pc/chr",chr,".txt", sep="")
  write.table(fdat, outfile, row.names=F, sep="\t", quote=F)              
}
