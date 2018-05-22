

geneDIR <- "/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/GS-geno/"
# geneDIR <- "~/Documents/Rotation3/data/gene_intersect/"
outTable <- "/lustre/scratch115/projects/interval_wgs/analysis/sv/geneIntersect/GS-geno-merge/GS_geno_merge.txt"



genefiles <- dir(geneDIR)


# Open the file, strip the colums, bind it to the current one.
totGenes <- NULL
for( i in 1:length(genefiles) ){
  
  file <- genefiles[i]
  nameFile.part <- gsub("_geneList.txt","",file)
  nameFile <- gsub("CNV_", "",nameFile.part)
  
  geneLoc <- paste(geneDIR,file, sep="/")
  genetable <- read.table(geneLoc)
  
  colnames(genetable) <- c("Exon", nameFile)

  
  if (i==1) {
    totGenes <- genetable
  } else {
    print(nameFile)
    totGenes <- merge(totGenes, genetable, by.x=c("Exon"), by.y=c("Exon"))
    

    gc()
    
  }

}
print("writing table to")
print(outTable)
write.table(totGenes, outTable, quote=F, row.names=F,  sep="\t")

