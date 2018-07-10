setwd("~/Documents/Rotations/Rotation3/data/geneIntersect/")


library(ComplexHeatmap)
library(circlize)
library(ggplot2)
library(pheatmap)

# 
# cnv.table <- read.table(file = "GS-geno/CNV_EGAN00001214506_geneList.txt")
# colnames(cnv.table) <- c("gene", "del")
# 
# bd.table <- read.table(file = "BD/EGAN00001214506_geneList.txt")
# colnames(bd.table) <- c("gene", "del")
# 
# 
# del.table <- merge(cnv.table, bd.table, by.x = "gene", by.y = "gene")
# colnames(del.table) <- c("gene", "cnv", "bd")
# 
# del.table$cnv <- ceiling(del.table$cnv )
# del.table$bd <- ceiling(del.table$bd )
# rownames(del.table) <- del.table$gene
# simp.del.table <- del.table[,-1]
# 
# # Heatmap(nonzero.del.table,cluster_rows =TRUE,cluster_columns=FALSE,  col = colorRamp2(c(-5, 0, 5), c("purple", "white", "orange")), show_row_names = FALSE)
# 
# 
# 
# 
# ggplot(data=bd.table, aes(bd.table$del)) + 
#   geom_histogram( binwidth = 1, fill="black", col="grey")# +
# coord_cartesian(ylim=c(0, 1000)) 
# 
# 
# # Where are there two zeros (therefore uninteresting)
# zero <- apply(simp.del.table, 1, function(v) any(as.numeric(v[1])!=0 | as.numeric(v[2])!=0 ))
# summary(zero)
# 
# # remove cases of zeroes in both
# nonzero.del.table <- simp.del.table[zero,]
# 
# 
# order(nonzero.del.table)
# pheatmap(nonzero.del.table, show_rownames = F)


Table <- read.table("/Users/bh10/Documents/Rotations/Rotation3/data/comparePlatforms/sum_intersect_BD_CNV.txt", header = T)
intersectTable <- subset(Table, select = c(sample, rawBD, rawGS, intersect))
colnames(intersectTable) <- c("sample","Breakdancer", "CNV_Genomestrip", "Intersection")
library(reshape2)

# Specify id.vars: the variables to keep but not split apart on
longInt <- melt(intersectTable, id.vars=c("sample"))



  
pdf("~/Documents/Rotation3/data/comparePlatforms/boxplot_BD_CNV_intersect.pdf", width = 5, height = 5)
ggplot(longInt,aes(x=variable, y=value)) +
  geom_boxplot( fill = "cornflowerblue") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 10, hjust = 1), legend.position = "none") +
  ylab("Number of intervals")+
  xlab("") +
scale_y_continuous(breaks = seq(0, 4500, 500))
  
graphics.off()


exon.CNV <- read.table("/Users/bh10/Documents/Rotation3/data/comparePlatforms/exons_with_dels-CNV.txt")
exon.GS <- read.table("/Users/bh10/Documents/Rotation3/data/comparePlatforms/exons_with_dels-disc.txt")
exon.BD <- read.table("/Users/bh10/Documents/Rotation3/data/comparePlatforms/exons_with_dels-BD.txt")

CNV.names <- exon.CNV[,1]
GS.names <- exon.GS[,1]
BD.names <-exon.BD[,1]


combine.genes <- list(CNV = CNV.names, GS = GS.names, BD = BD.names)


library (UpSetR)

pdf("~/Documents/Rotation3/Report/figs/gene_intersect.pdf", width = 5, height = 5, onefile = FALSE)
upset(fromList(combine.genes), order.by = "freq" ,text.scale = c(1.3, 1.3, 1, 1, 1.8, 1.3))
graphics.off()




## BD analysis
df.226 <-  read.table("/Users/bh10/Documents/Rotations/Rotation3/data/BD/filtered/BD_filtered_DEL_224_sorted.txt", header = TRUE)
df.226 <- df.226[,c(1:4,9)]
colnames(df.226) <- c("chr", "start", "end", "length", "sample" )
df.226$chr <-  factor(df.226$chr, levels= c(1:24))


EGAN00001361688 <- df.226[which(df.226$sample=="EGAN00001361688" | df.226$sample=="EGAN00001344763"),]
ggplot()+
  geom_density(data =EGAN00001361688,  alpha=0.50, aes(x=length), fill = "magenta") + 
  scale_x_continuous(limits = c( 50000,2500000)) + 
  geom_density(data = df.226, alpha=0.50, aes(x = length), fill = "blue") +
  theme_bw() 



# Per chromosome
pdf("~/Documents/Rotation3/data/comparePlatforms/BD_length_chr.pdf", width = 8, height = 5)
ggplot(EGAN00001361688, aes(x=length, fill=chr))+
  geom_density(alpha=0.80) + 
  scale_x_continuous(limits = c( 000,10000)) + 
  geom_density(alpha=0.90, fill = "white") +
  theme_bw() 
graphics.off()


# Per chromosome, zoom
pdf("~/Documents/Rotation3/data/comparePlatforms/BD_length_chr_zoom.pdf", width = 8, height = 5)
ggplot(df.226, aes(x=length, fill=chr))+
  geom_density(alpha=0.80) + 
  geom_density(alpha=0.90, fill = "white") +
  scale_x_continuous(limits = c( 2000,10000)) + 
  theme_bw()
graphics.off()

  
# # aggregate
# pdf("~/Documents/Rotation3/data/comparePlatforms/BD_length.pdf", width = 5, height = 5)
# ggplot(df.226, aes(x=length))+
#   geom_density(alpha=0.40, fill = "blue") + 
#   scale_x_continuous(limits = c( 0,10000)) + 
#   theme_bw() 
# graphics.off()
# 
# 
# # aggregate, zoom
# pdf("~/Documents/Rotation3/data/comparePlatforms/BD_length_zoom.pdf", width = 5, height = 5)
# ggplot(df.226, aes(x=length))+
#   geom_density(alpha=0.40, fill = "blue") + 
#   scale_x_continuous(limits = c( 700,10000)) + 
#   theme_bw()  
# graphics.off()



# Specify id.vars: the variables to keep but not split apart on
long.BD <- melt(df.226, id.vars=c("sample"))

## Length distributions, box plot method, 10,000max
ggplot(df.226,aes(x=chr, y=length)) +
  geom_boxplot( fill = "cornflowerblue") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 10, hjust = 1), legend.position = "none") +
  ylab("Length")+
  xlab("Chromosome") +
  scale_y_continuous( breaks = c(200,500,1000,2000,5000,10000), trans = 'log10', limits = c(200,10000)) #


xlabs <- paste(levels(df.226$chr),"\n(",table(df.226$chr),")",sep="") 

## Length distributions, box plot method, npmax
pdf("~/Documents/Rotation3/data/comparePlatforms/BD_length_box.pdf", width = 8, height = 5)
ggplot(df.226,aes(x=chr, y=length)) +
  geom_boxplot( fill = "cornflowerblue") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none") +
  ylab("Length")+
  xlab("Chromosome") +
  scale_y_continuous( breaks = c(200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000), trans = 'log10') +
  scale_x_discrete(labels=xlabs)
graphics.off()
# 
# chrs <- df.226$chr
# freq.chr <- as.data.frame(table(chrs))
# 
# # Number of dels per chr
# ggplot(df.226) +
#   geom_point(aes(x=levels(df.226$chr), y=table(df.226$chr))) +
#   theme_bw() +
#   theme(axis.text.x = element_text(angle = 10, hjust = 1), legend.position = "none") +
#   ylab("Number of deletions")+
#   xlab("Chromosome") 




##### GS DATA


## read
#cnv.226 <-  read.table("/Users/bh10/Documents/Rotation3/data/genomestrip/GS_filtered_DEL_CNV_no_genotype_info.txt", header = TRUE)
cnv.226 <-  read.table("/Users/bh10/Documents/Rotation3/data/genomestrip/GS_filtered_DEL_CNV.txt", header = TRUE)
cnv.226 <- subset(cnv.226, select = c("X.1.CHROM","X.2.POS0","X.3.END","X.4.ID","X.5.GCLENGTH", "hom.DELfreq" ,"het.DELfreq", "sample" ))
colnames(cnv.226) <- c("chr", "start", "end", "name", "length", "homfreq","hetfreq", "sample")
cnv.226$chr <-  factor(cnv.226$chr, levels= c(1:24))



# one line per record - factors in duplications
cnv.226.expanded <- cnv.226[rep(row.names(cnv.226), cnv.226$homfreq+cnv.226$hetfreq), 1:8]






# Per chromosome
pdf("~/Documents/Rotation3/data/comparePlatforms/CNV_length_chr.pdf", width = 8, height = 5)
ggplot(cnv.226.expanded, aes(x=length, fill=chr))+
  geom_density(alpha=0.40) + 
  scale_x_continuous(limits = c( 000,20000)) + 
  geom_density(alpha=0.80, fill = "white") +
  theme_bw() 
graphics.off()

#scale_fill_manual(values=c("#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9"))+

# Per chromosome, zoom
pdf("~/Documents/Rotation3/data/comparePlatforms/CNV_length_chr_zoom.pdf", width = 8, height = 5)
ggplot(cnv.226.expanded, aes(x=length, fill=chr))+
  geom_density(alpha=0.40) + 
  scale_x_continuous(limits = c( 1000,6000)) + 
  geom_density(alpha=0.80, fill = "white") +
  theme_bw()
graphics.off()


# # aggregate
# pdf("~/Documents/Rotation3/data/comparePlatforms/CNV_length.pdf", width = 5, height = 5)
# ggplot(cnv.226.expanded, aes(x=length))+
#   geom_density(alpha=0.40, fill = "blue") + 
#   scale_x_continuous(limits = c( 0,20000)) + 
#   theme_bw() 
# graphics.off()
# 
# 
# # aggregate, zoom
# pdf("~/Documents/Rotation3/data/comparePlatforms/BD_length_zoom.pdf", width = 5, height = 5)
# ggplot(df.226, aes(x=length))+
#   geom_density(alpha=0.40, fill = "blue") + 
#   scale_x_continuous(limits = c( 700,10000)) + 
#   theme_bw()  
# graphics.off()




# ## Length distributions, box plot method, 10,000max
# ggplot(cnv.226.expanded,aes(x=chr, y=length)) +
#   geom_boxplot( fill = "cornflowerblue") +
#   theme_bw() +
#   theme(axis.text.x = element_text(angle = 10, hjust = 1), legend.position = "none") +
#   ylab("Length")+
#   xlab("Chromosome") +
#   scale_y_continuous(breaks = c(200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000), trans = 'log10' ) # , limits = c(200,10000)


xlabs <- paste(levels(cnv.226.expanded$chr),"\n(",table(cnv.226.expanded$chr),")",sep="") 

## Length distributions, box plot method, npmax
pdf("~/Documents/Rotation3/data/comparePlatforms/CNV_length_box.pdf", width = 8, height = 5)
ggplot(cnv.226.expanded,aes(x=chr, y=length)) +
  geom_boxplot( fill = "cornflowerblue") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none") +
  ylab("Length")+
  xlab("Chromosome") +
  scale_y_continuous( breaks = c(200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000), trans = 'log10') +
  scale_x_discrete(labels=xlabs)
graphics.off()

## GS


## read
gs.226 <-  read.table("/Users/bh10/Documents/Rotation3/data/genomestrip/GS_filtered_DEL_disc.txt", header = TRUE)
colnames(gs.226) <- c("chr", "start", "end", "name", "length", "sample")
gs.226$chr <-  factor(gs.226$chr, levels= c(1:24))

# 
# # one line per record - factors in duplications
# gs.226.expanded <- gs.226[rep(row.names(gs.226), gs.226$DELfreq), 1:8]
# 
# 


# Per chromosome
pdf("~/Documents/Rotation3/data/comparePlatforms/GS_length_chr.pdf", width = 8, height = 5)
ggplot(gs.226, aes(x=length, fill=chr))+
  geom_density(alpha=0.40) + 
  scale_x_continuous(limits = c( 000,25000)) + 
  geom_density(alpha=0.80, fill = "white") +
  theme_bw() 
graphics.off()

#scale_fill_manual(values=c("#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9"))+

# # Per chromosome, zoom
# pdf("~/Documents/Rotation3/data/comparePlatforms/GS_length_chr_zoom.pdf", width = 8, height = 5)
# ggplot(gs.226, aes(x=length, fill=chr))+
#   geom_density(alpha=0.40) + 
#   scale_x_continuous(limits = c( 1000,6000)) + 
#   theme_bw()
# graphics.off()


# # aggregate
# pdf("~/Documents/Rotation3/data/comparePlatforms/CNV_length.pdf", width = 5, height = 5)
# ggplot(cnv.226.expanded, aes(x=length))+
#   geom_density(alpha=0.40, fill = "blue") + 
#   scale_x_continuous(limits = c( 0,20000)) + 
#   theme_bw() 
# graphics.off()
# 
# 
# # aggregate, zoom
# pdf("~/Documents/Rotation3/data/comparePlatforms/BD_length_zoom.pdf", width = 5, height = 5)
# ggplot(df.226, aes(x=length))+
#   geom_density(alpha=0.40, fill = "blue") + 
#   scale_x_continuous(limits = c( 700,10000)) + 
#   theme_bw()  
# graphics.off()




# ## Length distributions, box plot method, 10,000max
# ggplot(cnv.226.expanded,aes(x=chr, y=length)) +
#   geom_boxplot( fill = "cornflowerblue") +
#   theme_bw() +
#   theme(axis.text.x = element_text(angle = 10, hjust = 1), legend.position = "none") +
#   ylab("Length")+
#   xlab("Chromosome") +
#   scale_y_continuous(breaks = c(200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000), trans = 'log10' ) # , limits = c(200,10000)


xlabs <- paste(levels(gs.226$chr),"\n(",table(gs.226$chr),")",sep="") 

## Length distributions, box plot method, npmax
pdf("~/Documents/Rotation3/data/comparePlatforms/GS_length_box.pdf", width = 8, height = 5)
ggplot(gs.226,aes(x=chr, y=length)) +
  geom_boxplot( fill = "cornflowerblue") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none") +
  ylab("Length")+
  xlab("Chromosome") +
  scale_y_continuous( breaks = c(200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000), trans = 'log10') +
  scale_x_discrete(labels=xlabs)
graphics.off()


## Length distributions ALL


gs.226$software <- "GS"
cnv.226.expanded$software <- "CNV"
df.226$software <- "BD"

gs.red <- subset(gs.226, select=c(length,software))
cnv.red <- subset(cnv.226.expanded, select=c(length,software))
df.red <- subset(df.226, select=c(length,software))

tot.226 <- rbind(gs.red, cnv.red, df.red)

pdf("~/Documents/Rotation3/data/comparePlatforms/All_length_box.pdf", width = 4, height = 3)
ggplot(tot.226,aes(x=software, y=length, fill=software)) +
  guides(fill=FALSE) +
  geom_boxplot() +
  theme_bw() +
  ylab("Length (bp)")+
  xlab("")+
  scale_y_continuous( breaks = c(200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000), trans = 'log10') 
graphics.off()

pdf("~/Documents/Rotation3/data/comparePlatforms/All_length_dens.pdf", width = 4, height = 3)
ggplot(tot.226, aes(x=length, fill=software))+
  geom_density(alpha=0.80) + 
  scale_x_continuous(limits = c( 000,10000)) + 
  theme_bw() +
  xlab("Length (bp)")+
  theme(legend.position = c(0.765,0.78))
graphics.off()

### Length distribution of intersections

BD.CNV <- read.table("~/Documents/Rotation3/data/intersects/unique_BD_from_BD_CNV.txt")
BD.GS <- read.table("~/Documents/Rotation3/data/intersects/unique_BD_from_BD_GS.txt")
CNV.GS <- read.table("~/Documents/Rotation3/data/intersects/unique_CNV_from_CNV_GS.txt")

colnames(BD.CNV) <- c("chr", "start", "stop")
colnames(BD.GS) <- c("chr", "start", "stop")
colnames(CNV.GS) <- c("chr", "start", "stop")


BD.CNV$sample <- "BD.CNV"
BD.GS$sample <- "BD.GS"
CNV.GS$sample <- "CNV.GS"

all.interesected <- rbind(BD.CNV, BD.GS, CNV.GS)

all.interesected$length <- all.interesected$stop - all.interesected$start

pdf("~/Documents/Rotation3/data/comparePlatforms/length_dist_intersected_box.pdf", width = 8, height = 5)
ggplot(all.interesected,aes(x=sample, y=length)) +
  geom_boxplot( fill = "cornflowerblue") +
  theme_bw() +
  ylab("Length")+
  xlab("")+
  scale_y_continuous( breaks = c(200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000), trans = 'log10') 
graphics.off()

pdf("~/Documents/Rotation3/data/comparePlatforms/length_dist_intersected_dens.pdf", width = 8, height = 5)
ggplot(all.interesected, aes(x=length, fill=sample))+
  geom_density(alpha=0.80) + 
  scale_x_continuous(limits = c( 000,25000)) + 
  theme_bw() 
graphics.off()



set.seed(45)
chr <- rep(paste0("chr", 1:3), each=100)
pos <- rep(1:100, 3)
cov <- sample(0:500, 300)
df  <- data.frame(chr, pos, cov)

require(ggplot2)
p <- ggplot(data = cov )# ,aes(x=pos, y=cov)) + geom_area(aes(fill=chr)
p + facet_wrap(~ chr, ncol=1)


library(IRanges)
# 
# start <- cnv.226$start
# end <- cnv.226$end
# 
# x <- IRanges(start=start, end=end)
# cov <- coverage(x)
# # plot coverage
# plot(cov, type = "l"  , xlab = "position",   ylab = "frequency of gaps", main = "Coverage ")


## Number features

BD <- read.table("~/Documents/Rotation3/data/comparePlatforms/BD_numDels.txt")
colnames(BD) <- c("num", "sample")
BD$sw <- "BD"

BD <- read.table("~/Documents/Rotation3/data/comparePlatforms/filtDEL_BD.txt")
colnames(BD) <- c("num", "sample")
BD$sw <- "BDFilt"

pdf("~/Documents/Rotation3/data/comparePlatforms/NumDelsBD", width = 8, height = 5)
ggplot(BD,aes(x=sw,y=num)) +
  geom_boxplot( fill = "cornflowerblue") +
  theme_bw() +
  ylab("Length")+
  xlab("")#+
  scale_y_continuous( breaks = c(200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000), trans = 'log10') 
graphics.off()
