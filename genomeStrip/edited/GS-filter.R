args = commandArgs(TRUE)

## Arguments: 

# # DIRs
# file.DIR <- args[1]
# 
# out.DIR <- args[2]
# # 
# # 
# # # Sample
# sample.name.ext < #paste(file.DIR,args[3], sep="/")
# sample.name <- args[4]
# 
# # Which chroms
# selectedChroms <- args[8]
# 
# # Coordinate tables
# centromere.coord <- args[5]  # Table containing coordinates of centromeres
# gaps.coord <- args[6]        # Table containing coordinates of gaps
# more.gaps.coord <- args[7]   # Table containing coordinates of more gaps

# # Out tables
# sv.table.full <- paste(out.DIR, "/", paste("BD_raw_all_SV", sample.name, sep="_"), ".txt", sep="")        # Write to table containing all SVs in std chromosomes
# freq.SV.out <- paste(out.DIR, "/", paste("BD_SV_frequency", sample.name, sep="_"), ".txt", sep="")        # Write to table contatining frequency of each SV type
# filtered.dels.out <- paste(out.DIR, "/", paste("BD_filtered_DEL", sample.name, sep="_"), ".txt", sep="")  # Write to table containing filtered deletions
# sv.table.DEL <- paste(out.DIR, "/", paste("BD_raw_DEL", sample.name, sep="_"), ".txt", sep="")            # Write to table containing DELs in std chromosomes

# 
# 
# # DIRs
file.DIR <- "/Users/bh10/Documents/Rotation3/data/genomestrip/"
out.DIR <- "/Users/bh10/Documents/Rotation3/data/genomestrip/"


# Sample
sample.name.ext <- paste(file.DIR,"gs_cnv.reduced.genotypes.txt" , sep="/")
sample.name <- "CNV"

# Which chroms
selectedChroms <- "autosomes"

# Coordinate tables
centromere.coord <- "/Users/bh10/Documents/Rotation3/data/hg38/centromere_GRCh38_combined.txt"  # Table containing coordinates of centromeres
gaps.coord <- "/Users/bh10/Documents/Rotation3/data/hg38/gaps_GRCh38.txt"                       # Table containing coordinates of gaps
more.gaps.coord <- "/Users/bh10/Documents/Rotation3/data/hg38/gaps_human.txt"                   # Table containing coordinates of more gaps

# 
# # Out tables
sv.table.full <- paste(out.DIR, "/", paste("GS_raw_all_SV", sample.name, sep="_"), ".txt", sep="")         # Write to table containing all SVs in std chromosomes
freq.SV.out <- paste(out.DIR, "/", paste("GS_SV_frequency", sample.name, sep="_"), ".txt", sep="")         # Write to table contatining frequency of each SV type
filtered.dels.out <- paste(out.DIR, "/", paste("GS_filtered_DEL", sample.name, sep="_"), ".txt", sep="")   # write to table containing filtered deletions
sv.table.DEL <- paste(out.DIR, "/", paste("GS_raw_DEL", sample.name, sep="_"), ".txt", sep="")             # Write to table containing DELs in std chromosomes




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


## Libraries
library("ggplot2")#, lib.loc="/nfs/team151/software/Rlibs/")
library("plyr")





## Code

# Read in samples 
df <- read.table(sample.name.ext, fill = TRUE, header=TRUE, check.names = FALSE)

# Filter for Chr1-22,X,Y,M

## Do we want to consider the sex chromosomes?
if (selectedChroms == "autosomes") {
  chroms <- paste("chr", c(1:22), sep="")
} else {
  chroms <- paste("chr", c(1:22,"X","Y","M"), sep="")
}

fdat <- NULL
for (i in 1:length(chroms))  {
  print(c("filtering for chromosome", i))
  indchr <- df[,1]==chroms[i]
  fdat <- rbind(fdat, df[indchr,])
}
write.table(fdat, sv.table.full, quote=F, row.names=F,  sep="\t")    # 784,828

# Split out DELs

# count the number of 0s, 1s, 2s and greater than 2s (homDEL, hetDEL, no DEL, DUP)
fdat$hom.DELfreq <- rowSums(fdat[, c(6:ncol(fdat))] == 0)
fdat$het.DELfreq <- rowSums(fdat[, c(6:ncol(fdat))] == 1)
fdat$ref <- rowSums(fdat[, c(6:ncol(fdat))] == 2)
fdat$DUPfreq <- rowSums(fdat[, c(6:ncol(fdat))] >= 2)


# save the rows for which there is at least one zero (one DEL)
sv.hom.DELfreq <- fdat[!(fdat$hom.DELfreq==0),]
sv.het.DELfreq <- fdat[!(fdat$het.DELfreq==0),]
sv.ref <- fdat[!(fdat$ref==0),]
sv.DUPfreq <- fdat[!(fdat$DUPfreq==0),]

# Add a column that is the "type" of SV
sv.hom.DELfreq$SVType <- "homDEL"
sv.het.DELfreq$SVType <- "hetDEL"
sv.ref$SVType <- "ref"
sv.DUPfreq$SVType <- "DUP"

# remove unnecessary count columns
sv.hom.DELfreq <- subset(sv.hom.DELfreq, select= -c(het.DELfreq, ref, DUPfreq))
sv.het.DELfreq <- subset(sv.het.DELfreq, select= -c(hom.DELfreq, ref, DUPfreq))
sv.ref <- subset(sv.ref, select= -c(hom.DELfreq,het.DELfreq, DUPfreq))
sv.DUPfreq <- subset(sv.DUPfreq, select= -c(hom.DELfreq , het.DELfreq, ref))


## rename specific frequency column to the word "freq"
sv.hom.DELfreq <- rename(sv.hom.DELfreq, c("hom.DELfreq"="freq"))
sv.het.DELfreq <- rename(sv.het.DELfreq, c("het.DELfreq"="freq") )
sv.ref  <-  rename(sv.ref, c("ref"="freq") )
sv.DUPfreq <-  rename(sv.DUPfreq, c("DUPfreq"="freq") )

## Combine tables
sv.DEL <- rbind(sv.hom.DELfreq, sv.het.DELfreq)
sv.all <- rbind(sv.hom.DELfreq, sv.het.DELfreq, sv.ref, sv.DUPfreq) # In case this is ever wanted...

write.table(sv.DEL, sv.table.DEL, quote=F, row.names=F,  sep="\t") 

# Report the number of each kind of SV
freq.SV <- as.data.frame(table(sv.all[,"SVType"]))
colnames(freq.SV) <- c("SVType", "frequency")

write.table(freq.SV, freq.SV.out, quote=F, row.names=F,  sep="\t")
## 



sv.DEL$delLength <- sv.DEL$`[3]END`-sv.DEL$`[2]POS0`
# edit chrs, so that chr1 -> 1, and chrY -> 24 and unnecessary columns are removed.
edels <- edit.chr(sv.DEL[,c("[1]CHROM","[2]POS0", "[3]END", "[4]ID" ,"delLength","SVType", "freq")])



##########



# Read in centromeres 
centro <- read.delim(centromere.coord, stringsAsFactors=F, header=T)
colnames(centro) <- c("chr", "start", "stop")
centro <- edit.chr(centro[1:3]) # function converts centromere coords into same format as sv.DEL table

# Read in gaps
gaps <- read.table(gaps.coord, stringsAsFactors=F, header=F)           ## 819
names(gaps) <- c("bin","chrom","chromStart","chromEnd","ix","n","size","type","bridge")

# remove gaps with bridges
indg <- which(gaps$bridge=="no") 
gaps <- edit.chr(gaps[indg,2:4])

# Read in additional gaps
fgaps <- read.table(more.gaps.coord, stringsAsFactors=F, header=F)
colnames(fgaps) <- c("chr", "start", "stop")
table(fgaps[,1])
mgaps <- na.omit(edit.chr(fgaps)) # NAs introduced? It's because of non-standard chromosomes included in the gap file


## Commence filtering    

## filter for deletion size
summary(edels$delLength)
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# -91109      439      633   349727     3781 78180680 
indsize <- edels$delLength > 50 & edels$delLength < 1000000
print("deletion size filtering")
summary(indsize)


# filter for inner distance
summary(edels[,3]-edels[,2])
#   Min.  1st Qu.   Median     Mean      3rd Qu.     Max. 
#    28      360      606      360266     3376     78180625 
indin <- (edels[,3]-edels[,2]) > 50 & (edels[,3]-edels[,2]) < 1000000 
print("inner distance filtering: ")
summary(indin)


# Do not need to complete for GS
# # filter for number of RPs
# round(summary(edels[,6]))
# #  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# #   2       3       6       8       9     1809 
# indrp <- edels[,6] < 20 
# print("read pair filtering:")
# summary(indrp)

# filter for size, inner distance & number of RPs
part.filt.dels <- edels[which(indsize &  indin ),] # & indrp & indrd 



# Filter for location based features

# Gaps - first one
indga <- apply(part.filt.dels[,1:3], 1, function(v) any(as.numeric(v[1])==as.numeric(gaps[,1]) & ((as.numeric(v[2])>=(as.numeric(gaps[,2])-50) & (as.numeric(v[2])+100)<=(as.numeric(gaps[,3])+50)) |  (as.numeric(v[3])>=(as.numeric(gaps[,2])-50) & (as.numeric(v[3])+100)<=(as.numeric(gaps[,3])+50))))) 

# Gaps - second one
indgb <- apply(part.filt.dels[,1:3], 1, function(v) any(as.numeric(v[1])==as.numeric(mgaps[,1]) &  ((as.numeric(v[2])>=(as.numeric(mgaps[,2])-1000) & (as.numeric(v[2])+100)<=(as.numeric(mgaps[,3])+1000)) | (as.numeric(v[3])>=(as.numeric(mgaps[,2])-1000) & (as.numeric(v[3])+100)<=(as.numeric(mgaps[,3])+1000)))))

# Centromeres
indc <- apply(part.filt.dels[,1:3], 1, function(v) any(as.numeric(v[1])==as.numeric(centro[,1]) &  ((as.numeric(v[2])>=(as.numeric(centro[,2])-1000) & (as.numeric(v[2])+100)<=(as.numeric(centro[,3])+1000)) |  (as.numeric(v[3])>=(as.numeric(centro[,2])-1000) & (as.numeric(v[3])+100)<=(as.numeric(centro[,3])+1000)))))

 
filt.all <- !indga & !indgb & !indc 
filtered.dels <- part.filt.dels[filt.all,]

filtered.dels$sample <- sample.name
write.table(filtered.dels, filtered.dels.out, quote=F, row.names=F,  sep="\t")

print("complete, exiting :)")

