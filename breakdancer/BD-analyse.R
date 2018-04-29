setwd("~/Documents/Rotation3/data/BD/WG_full/")


edit.chr <- function(mat, chrn=1, posn=2, ord=TRUE)  {
  chr <- as.character(mat[,chrn])
  chr <- gsub("chr","", chr)
  chr <- gsub("Chr","", chr)
  chr[chr=="X"] <- 23
  chr[chr=="Y"] <- 24
  mat[,chrn] <- as.numeric(chr)
  if(ord)  {
    ## order by chr and start position
    ord <- order(as.numeric(as.character(mat[,chrn])), as.numeric(as.character(mat[,posn])))
    mat <- data.frame(mat[ord,], stringsAsFactors=F, row.names=1:nrow(mat))
  }
  mat
}

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
## 

# split into SV types
sv.CTX <- subset(fdat, TypeSV=="CTX")
sv.DEL <- subset(fdat, TypeSV=="DEL")
sv.INS <- subset(fdat, TypeSV=="INS")
sv.INV <- subset(fdat, TypeSV=="INV")
sv.ITX <- subset(fdat, TypeSV=="ITX")


##  Filter for centromeres and gaps

# klaudia [3:53 PM]
# I changed group from team29 to team151, so should be accessible now.
# Maybe better to use /nfs/users/nfs_k/kw8/data/genome_info/centromere_GRCh38_combined.txt
# also you could use 
# ~kw8/data/genome_info/gaps_GRCh38.txt


## Other code: 
    # fn <- paste("/lustre/scratch113/projects/g1k-sv/g1k-phaseIII/breakdancer/combined_raw/chr",chr,".txt.gz", sep="")
    dels <- sv.DEL  # read.delim(fn, stringsAsFactors=F) 
    human <- read.delim("/Users/bh10/Documents/Rotation3/data/hg38/centromere_GRCh38_combined.txt", stringsAsFactors=F, header=T)
    colnames(human) <- c("chr", "start", "stop")
    ## prepare gaps
    #indg <- which(human[,5]=="clone" | human[,5]=="contig") 
    ### separate in to clones, contigs and centromeres
    #hgaps <- edit.chr(human[indg,1:3])
    hcentro <- edit.chr(human[1:3])
    ## edit chrs, so that chr1 -> 1, and chrY -> 24 and unnecessary columns are removed.
    edels <- edit.chr(dels[,c(1,2,5,8:12)])

    
    ## The gaps
    gaps <- read.table("/Users/bh10/Documents/Rotation3/data/hg38/gaps_GRCh38.txt", stringsAsFactors=F, header=F)           ## 819
    names(gaps) <- c("bin","chrom","chromStart","chromEnd","ix","n","size","type","bridge")
    table(gaps[,8])
    
    ## prepare gaps
    indg <- which(gaps$bridge=="no") 
    gaps <- edit.chr(gaps[indg,2:4])
    
    ## Read in additional gaps
    fgaps <- read.table("/Users/bh10/Documents/Rotation3/data/hg38/gaps_human.txt", stringsAsFactors=F, header=F)
    colnames(fgaps) <- c("chr", "start", "stop")
    table(fgaps[,1])
    mgaps <- na.omit(edit.chr(fgaps)) # NAs introduced because of non-standard chromosomes
   

    
    
    ## filter for deletion size
    summary(edels$SizeSV)
    # Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    # -91109      439      633   349727     3781 78180680 
    indsize <- edels$SizeSV > 50 & edels$SizeSV < 1000000
    summary(indsize)
    
    
    # ## filter for read depth
    # summary(edels$RDratio)
    # ##   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    # ## 0.0000  0.7164  0.9350  0.9128  1.0810  9.4120     180 
    # indrd <- edels$RDratio < 0.75
    
    ## filter for inner distance
    summary(edels[,3]-edels[,2])
    ##   Min.  1st Qu.   Median     Mean      3rd Qu.     Max. 
    ##    28      360      606      360266     3376     78180625 
    indin <- (edels[,3]-edels[,2]) > 50 & (edels[,3]-edels[,2]) < 1000000 
    summary(indin)
    
    
    
    ## filter for number of RPs
    round(summary(edels[,6]))
    ##  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   2       3       6       8       9     1809 
    indrp <- edels[,6] < 20 
    summary(indrp)
    boxplot(edels$numReadPairs, ylim = c(0,100))
    
    
    ## filter for size, RD, inner distance & number of RPs
    sdels <- edels[which(indsize &  indin & indrp),] #indrd &     
    
    
    

    ## filter DEL for location (gaps and centromeres and telomeres and alpha stellites  )
    indg <- apply(sdels[,1:3], 1, function(v) any(as.numeric(v[1])==as.numeric(gaps[,1]) &
      ((as.numeric(v[2])>=(as.numeric(gaps[,2])-50) & (as.numeric(v[2])+100)<=(as.numeric(gaps[,3])+50)) |
       (as.numeric(v[3])>=(as.numeric(gaps[,2])-50) & (as.numeric(v[3])+100)<=(as.numeric(gaps[,3])+50))))) 
    
    indc <- apply(sdels[,1:3], 1, function(v) any(as.numeric(v[1])==as.numeric(hcentro[,1]) &
            ((as.numeric(v[2])>=(as.numeric(hcentro[,2])-1000) & (as.numeric(v[2])+100)<=(as.numeric(hcentro[,3])+1000)) |
            (as.numeric(v[3])>=(as.numeric(hcentro[,2])-1000) & (as.numeric(v[3])+100)<=(as.numeric(hcentro[,3])+1000)))))

    indg <- apply(sdels[,1:3], 1, function(v) any(as.numeric(v[1])==as.numeric(mgaps[,1]) &
     ((as.numeric(v[2])>=(as.numeric(mgaps[,2])-1000) & (as.numeric(v[2])+100)<=(as.numeric(mgaps[,3])+1000)) |
      (as.numeric(v[3])>=(as.numeric(mgaps[,2])-1000) & (as.numeric(v[3])+100)<=(as.numeric(mgaps[,3])+1000)))))
    

    
#    any(Same Chromosome) &
 #         ((DEL start>=(CENTRO start-1000) & (DEL start+100)<=(CENTRO End+1000)) |
  #           (as.numeric(v[3])>=(as.numeric(hcentro[,2])-1000) & (as.numeric(v[3])+100)<=(as.numeric(hcentro[,3])+1000)))))



    inda <- !indc & !indg & !indg
    gdels <- sdels[inda,]






# 
# dat.del <- subset(fdat, TypeSV=="DEL")
# dat.ins <- subset(fdat, TypeSV=="INS")
# dat.ins$SizeSV <- dat.ins$SizeSV*-1
# dat.both <- rbind(dat.del, dat.ins)
# 
# 
# 
# ggplot() +
#   theme_classic() +
#   
#   geom_point(data=dat.del, aes(x=Position1, y=SizeSV, colour=ConfidenceScore), alpha = .2, size = 3) +
#   geom_point(data=dat.ins, aes(x=Position1, y=SizeSV, colour=ConfidenceScore), alpha = .2, size = 3) +
#   xlab("DELs") +
#   ylab("Length") +
#   scale_y_continuous(trans='log10')
#   
#   
#   
#   
#   ggplot(dat.both, aes(x=SizeSV, fill=TypeSV)) +
#     geom_density(alpha=0.20) + 
#     scale_x_continuous(limits = c(0, 1000)) + 
#     theme_bw()
#   
#   
#   
#   fdat$ConfidenceScore
#   
#   
# 

# 

# 
