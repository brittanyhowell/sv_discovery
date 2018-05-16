geneTable <- read.table("~/Documents/Rotation3/data/gene_intersect/head.txt")

geneDIR <- "~/Documents/Rotation3/data/gene_intersect"
genefiles <- dir(geneDIR)



genReduce <- geneTable[,c(1,5)]

# Open the file, strip the colums, bind it to the current one.
totGenes <- NULL
for( i in 1:length(genefiles) ){
  
  file <- genefiles[i]
  nameFile <- gsub("_geneList.txt","",file)
  
  geneLoc <- paste(geneDIR,file, sep="/")
  genetable <- read.table(geneLoc)
  
  genReduce <- genetable[,c(1,5)]
  colnames(genReduce) <- c("Exon", nameFile)

  
  if (i==1) {
    totGenes <- genReduce
  } else {
    print(nameFile)
    totGenes <-  cbind(totGenes, genReduce[,2])
    colnames(totGenes)[i+1] <- nameFile
    
    
  }

}
