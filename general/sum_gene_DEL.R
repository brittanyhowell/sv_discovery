args = commandArgs(TRUE)
## Count the number of genes knocked out by all 226 samples in three platforms


cnv.table <- read.table(args[1], header = T)
outTable <- args[2]
# cnv.table <- read.table("~/Documents/Rotation3/data/geneIntersect/tiny_geno_merge.txt", header = T)


cnv.table$Sum <- cnv.table[,2]# rowSums(cnv.table[,2:ncol(cnv.table)])
cnv.table.dels <- cnv.table[!(cnv.table$Sum==0),]  

write.table(cnv.table.dels, outTable, quote=F, row.names=F,  sep="\t")
