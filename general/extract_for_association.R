args = commandArgs(TRUE)


## Samples: Get the Phenotypes File, and - awk '{print $1}' FBC_223-samples.txt or whatever it is. 
samples <- read.table("/nfs/team151/bh10/scripts/bh10_general/fileLists/223Samples.list", as.is = TRUE)
cnv.table <-  read.table(file = "/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/merged/GS_geno_merge.txt", header = T)


outTable <- args[1]



## Reorder DEL table so that it is the same order of samples as the phenotype sample list
fdat <- as.data.frame(cnv.table$Exon)
colnames(fdat) <- "Exon"
# for (i in 1:10) {
  
  ## Issue in the conversion of this. It needs to loop through and become a string with quotes but I can't get that to work
  # ourSample <- as.vector(as.matrix(samples[5,]))
  
   ind <- sapply(as.vector(as.matrix(samples)), function(v) which(names(cnv.table)==v))
   outdat <- cnv.table[,ind]
   
   out<- cbind(fdat,outdat)
  # ourSample <- "EGAN00001214509"

  
  # dat.load <- cnv.table[ourSample]
  # fdat <- cbind(fdat,dat.load)
# }

## Produced full list

write.table(out, outTable)
