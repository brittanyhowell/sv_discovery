# source("/nfs/users/nfs_k/kw8/R_dir/R_scripts/load_nsta_functions.R")

# bsub -o /nfs/team151/bh10/scripts/breakdancer_bh10/output/get_insertion_sizes.out -e /nfs/team151/bh10/scripts/breakdancer_bh10/output/get_insertion_sizes.err  R CMD BATCH /nfs/team151/bh10/scripts/breakdancer_bh10/get_BD_thresholds.R


### Generate a proper deletion density distribution by adding
### endpoints with probablity zero to the left (min-delta.x) and to
### the right (max+delta.x) of an empirical deletion density and
### normalise the distribution
# dd = empirical density of the expected deletion distribution
get.emp.density <- function(dd)  {
  delta.x <- dd$x[2] - dd$x[1]
  dd$x <- c(min(dd$x)-delta.x, dd$x, max(dd$x)+delta.x)
  dd$y <- c(0, dd$y, 0)
  dd$y <- dd$y/(sum(dd$y)*delta.x)
  dd
}

### Fits a density function to insert size distribution and
### finds the RP separation below density y = 0.001/100
### which is the slope of the tangent of the CDF (=quantiles plot)
### which corresponds to a change of 0.001 new calls within next 100
get.density.thresh <- function(f)  {
  dd <- density(f[f>0 & f < 10000], bw=1, n=1024)
  dd <- get.emp.density(dd)
  yt <- 0.001/100
  qu <- round(quantile(f[f>0], probs=0.99))
  indx <- which(dd$x > qu)
  indy <- which(dd$y[indx] < yt)
  x <- round(dd$x[indx][indy][1])
  x
}

##### Insert size distributions for proper pairs by sample #####
## f = insert sizes
## id = samples name
collate.summary.sample <- function(f, id, xlimit=1000)  {
  s <- NULL
  if (length(f)!=0)  {
    ## collate summaries
    if (any(f>0 & f<10000))  {
      sde <- round(sd(f[f > 0 & f < xlimit]))
      emp.thresh <- get.density.thresh(f)
    }  else  {
      sde <- NA
      emp.thresh <- 0
    }
    s <- c(id, summary(f), sde, round(mad(f[f>0])), length(f), emp.thresh)
  }
  s
}


##### Plots insert size distribution #####

d <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files", full.names=TRUE)
fn <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files")
pdf("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/plots/insert_size_distribution_test.pdf", width=10, height=10, pointsize=12, onefile=TRUE)
#pdf("/lustre/scratch114/projects/hgdp_wgs/sv/plots/insert_size_distribution_30-01-2016.pdf", width=10, height=10, pointsize=12, onefile=TRUE)
par(mfrow=c(3,3), mai=c(0.6,0.6,0.5,0.1))
for (i in 1:length(d))  {
  print(i)
  f <- scan(d[i])
  plot(density(f, from=0, to=1000), col="blue", main=fn[i])
}
dev.off()



# ##### Collate summaries by sample #####

# info <- read.delim("/lustre/scratch114/projects/hgdp_wgs/meta/sanger-HGDP-sequenced.270115.w-irods-bams.txt", stringsAsFactors=F)
# d <- dir("/lustre/scratch114/projects/hgdp_wgs/sv/inserts", full.names=TRUE)         ## 176
# s <- NULL
# for (i in 1:length(d))  {       ## loop through samples
#   print(i)
#   v <- unlist(strsplit(d[i], "/"))[8]
#   id <- unlist(strsplit(v, "\\."))[1]
#   f <- scan(d[i])
#   s <- rbind(s, collate.summary.sample(f, id, xlimit=3000))
# }
# s <- data.frame(s)
# names(s) <- c("ID","Min","1stQu","Median","Mean","3rdQu","Max","SD","MAD","N","Thresh")
# #write.table(s, "/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_summary_by_sample_26-01-2016.txt", quote=F, row.names=F, sep="\t")    ## 176
# #write.table(s, "/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_summary_by_sample_30-01-2016.txt", quote=F, row.names=F, sep="\t")    ## 176



# ##### Analyse summaries and edit thresholds for libs #####

# #s <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_summary_by_sample_26-01-2016.txt", stringsAsFactors=F)   ## 176
# s <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_summary_by_sample_30-01-2016.txt", stringsAsFactors=F)   ## 176
# sthresh1 <- s$Median + 4*s$SD
# sthresh2 <- s$Median + 5*s$MAD
# round(summary(sthresh1))
# round(summary(sthresh2))
# round(summary(s$Thresh))
# ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     NAs
# ##     512     595     605     602     612     631
# ##     563     645     652     652     664     686
# ##     566     627     637     636     647     670       4
# ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# ##     542     604     612     611     620     639
# ##     584     652     661     661     672     695
# ##     566     624     635     634     644     669

# ## choose max as threshold
# MaxThresh <- apply(cbind(sthresh1,sthresh2,s$Thresh), 1, max)
# fdat <- data.frame(s, MaxThresh)         
# #write.table(fdat, "/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_thresh_by_sample.txt", quote=F, row.names=F, sep="\t")    ##  176


# ##### Plot Thresh against MaxTresh #####
# f <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_thresh_by_sample.txt", stringsAsFactors=F)
# plot(f$Thresh, f$MaxThresh)
# abline(0,1)


# ##### Compile file locations and thresholds #####

# f <- read.delim("/lustre/scratch114/projects/hgdp_wgs/sv/analysis/insert_thresh_by_sample.txt", stringsAsFactors=F)
# dirID <- vecstr2matstr(f[,1], "_")[,1]
# fdat <- data.frame(dirID, f$ID, f$MaxThresh)
# #write.table(fdat, "/lustre/scratch114/projects/hgdp_wgs/sv/analysis/sample_info.txt", row.names=F, col.names=F, sep="\t", quote=F)
