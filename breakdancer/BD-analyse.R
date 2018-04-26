setwd("~/Documents/Rotation3/data/BD/WG_full/")


library(ggplot2)







df <- read.table("EGAN00001344523.out", fill = TRUE)
colnames(df) <- c("Chr1", "Pos1", "Orientation1", "Chre2", "Pos2", "Orientation2", "TypeSV", "SizeSV", "ConfidenceScore", "numReadPairs", "numReadPairsPerMapFile", "EstimatedAlleleFreq")


### Filter for Chr1-22,X,Y and GCRh38 gaps, centromeres and telomeres and other things #####

##  select chr1-22,X,Y
 chroms <- paste("chr", c(1:22,"X","Y"), sep="")
 fdat <- NULL
 for (i in 1:length(chroms))  {
   print(i)
   indchr <- df[,1]==chroms[i] & df[,4]==chroms[i]
   fdat <- rbind(fdat, df[indchr,])
 }
write.table(fdat, "BD_test_chr1-22-X-Y.txt", quote=F, row.names=F,  sep="\t")    # 784,828
 

## Report the number of each kind of SV
# Work out the unique types
typeSV.unique <- unique(fdat$TypeSV)

# Count those types
typeSV.count <- as.data.frame(sapply(typeSV.unique, function (x){sum(fdat$TypeSV == x)}))
# and bind together
typeSV.bind <- cbind(typeSV.unique, typeSV.count)
colnames(typeSV.bind) <- c("typeSV","SampleNameProbs")  ## Hey future brie, this bit could be used to make a table per sample

write.table(typeSV.bind, "breakdownOfSVTypes.txt", quote=F, row.names=F,  sep="\t")


dat.del <- subset(fdat, TypeSV=="DEL")
dat.ins <- subset(fdat, TypeSV=="INS")
dat.ins$SizeSV <- dat.ins$SizeSV*-1
dat.both <- rbind(dat.del, dat.ins)



ggplot() +
  theme_classic() +
  
  geom_point(data=dat.del, aes(x=Position1, y=SizeSV, colour=ConfidenceScore), alpha = .2, size = 3) +
  geom_point(data=dat.ins, aes(x=Position1, y=SizeSV, colour=ConfidenceScore), alpha = .2, size = 3) +
  xlab("DELs") +
  ylab("Length") +
  scale_y_continuous(trans='log10')
  
  
  
  
  ggplot(dat.both, aes(x=SizeSV, fill=TypeSV)) +
    geom_density(alpha=0.20) + 
    scale_x_continuous(limits = c(0, 1000)) + 
    theme_bw()
  
  
  
  fdat$ConfidenceScore
  
  



