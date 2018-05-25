args = commandArgs(TRUE)


## Samples: Get the Phenotypes File, and - awk '{print $1}' FBC_223-samples.txt or whatever it is. 
samples <- read.table("/nfs/team151/bh10/scripts/bh10_general/fileLists/223Samples.list", as.is = TRUE)
# samples <- read.table("~/Documents/Rotation3/data/phenotypes/223Samples.list" , as.is = TRUE)
cnv.table <-  read.table("/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/merged/GS_geno_merge.txt", header = T)
# cnv.table <- read.table("~/Documents/Rotation3/data/geneIntersect/tiny_geno_merge.txt", header = T)

head(cnv.table[,1:5])

outTable <- args[1]

fdat <- as.data.frame(cnv.table$Exon)

  
   ind <- unlist(sapply(as.vector(as.matrix(samples)), function(v) which(names(cnv.table)==v)))
 
   outdat <- cnv.table[,ind]
   
   out<- cbind(fdat,outdat)
   colnames(out)[1] <- "Exon"

## Produced full list

write.table(out, outTable)
