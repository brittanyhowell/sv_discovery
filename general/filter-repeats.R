repeats.coord <- "/Users/bh10/Documents/Rotation3/data/hg38/ucsc_repeats_GRCh38.txt.gz"         # Table containing coordinate of all repeats

# DIRs
file.DIR <- "/Users/bh10/Documents/Rotation3/data/genomestrip/"
out.DIR <- "/Users/bh10/Documents/Rotation3/data/genomestrip/"


# Sample
sample.name.ext <- paste(file.DIR,"gs_cnv.reduced.genotypes.txt" , sep="/")
sample.name <- "CNV"



## Functions
edit.chr <- function(mat, chrn=1, posn=2, ord=TRUE)  {
  chr <- as.character(mat[,chrn])
  chr <- gsub("chr","", chr)
  chr <- gsub("Chr","", chr)
  chr[chr=="X"] <- 23
  chr[chr=="Y"] <- 24
  chr[chr=="M"] <- 25
  mat[,chrn] <- as.numeric(chr)
  if(ord)  {
    ## order by chr and start position
    ord <- order(as.numeric(as.character(mat[,chrn])), as.numeric(as.character(mat[,posn])))
    mat <- data.frame(mat[ord,], stringsAsFactors=F, row.names=1:nrow(mat))
  }
  mat
}


# Read in samples 
df <- read.table(sample.name.ext, fill = TRUE, header=TRUE, check.names = FALSE)

# Filter for Chr1-22,X,Y,M

chroms <- paste("chr", c(1:22,"X","Y","M"), sep="")
fdat <- NULL
for (i in 1:length(chroms))  {
  print(c("filtering for chromosome", i))
  indchr <- df[,1]==chroms[i]
  fdat <- rbind(fdat, df[indchr,])
}




# Test read in repeats
full.repeats <- read.table(repeats.coord, header = F)
repeats <- full.repeats[,c(6:8, 10:13)]
colnames(repeats) <- c("chr", "start", "end", "strand", "repName", "repClass", "repFamily")
rep <- na.omit(edit.chr(repeats[1:3]))

sv.table <- 
  
  
  
# Filter out all segments containing a repeat
# Columns in sv.table neeed to be: 
# Col1: chr, col 2: start, Col 3: end.

indr <- apply(sv.table[,1:3], 1, function(v)   any(as.numeric(v[1])==as.numeric(rep[,1]) &  ((as.numeric(v[2])>=(as.numeric(rep[,2])-1000) & (as.numeric(v[2])+100)<=(as.numeric(rep[,3])+1000)) |   (as.numeric(v[3])>=(as.numeric(rep[,2])-1000) & (as.numeric(v[3])+100)<=(as.numeric(rep[,3])+1000))))) 


