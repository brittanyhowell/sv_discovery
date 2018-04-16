setwd("~/Documents/Rotation3/scripts/breakdancer/test_BD_out/")


### Filter for Chr1-22,X,Y and GCRh38 gaps, centromeres and telomeres and other things #####


 dels <- read.table("EGAN00001214492.out", stringsAsFactors=F)  
 table(dels[,1])
##  select chr1-22,X,Y
 chroms <- paste("chr", c(1:22,"X","Y"), sep="")
 fdat <- NULL
 for (i in 1:length(chroms))  {
   print(i)
   indchr <- dels[,1]==chroms[i] & dels[,4]==chroms[i]
   fdat <- rbind(fdat, dels[indchr,])
 }
#write.table(fdat, "/lustre/scratch114/projects/hgdp_wgs/sv/breakdancer/combined/BD_combined_raw_chr1-22-X-Y.txt", quote=F, row.names=F, sep="\t")     784,828
 

 