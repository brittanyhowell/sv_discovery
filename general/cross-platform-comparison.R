setwd("~/Documents/Rotation3/data/geneIntersect/")


library(ComplexHeatmap)
library(circlize)

library(pheatmap)


cnv.table <- read.table(file = "GS-geno/CNV_EGAN00001214506_geneList.txt")
colnames(cnv.table) <- c("gene", "del")

bd.table <- read.table(file = "BD/EGAN00001214506_geneList.txt")
colnames(bd.table) <- c("gene", "del")


del.table <- merge(cnv.table, bd.table, by.x = "gene", by.y = "gene")
colnames(del.table) <- c("gene", "cnv", "bd")

del.table$cnv <- as.numeric(del.table$cnv )
del.table$bd <- as.numeric(del.table$bd )
rownames(del.table) <- del.table$gene
del.table <- del.table[,-1]

new.del <- head(del.table, n = 10000)
new.del <- tail(new.del, n = 2000)


Heatmap(new.del,cluster_rows =TRUE,cluster_columns=FALSE,  col = colorRamp2(c(-5, 0, 5), c("purple", "white", "orange")), show_row_names = FALSE)

pheatmap(new.del)


ggplot(data=bd.table)


##
##Intersects


## Upset Plots






df.226 <-  read.table("/Users/bh10/Documents/Rotation3/data/BD/filtered/BD_filtered_DEL_224_sorted.txt", header = TRUE)
colnames(df.226) <- c("chr", "start", "end", "length", "c", "n","m","o","p" )

df.226$chr <-  factor(df.226$chr, levels= c(1:24))
ggplot(df.226, aes(x=length, fill=chr))+
  geom_density(alpha=0.40) + 
  scale_x_continuous(limits = c( 000,8000)) + 
  theme_bw() +
  
  
  
  