# analyse filtered BD output


library(ggplot2)


setwd("/Users/bh10/Documents/Rotation3/data/BD/filtered")


df.226 <-  read.table("/Users/bh10/Documents/Rotation3/data/BD/filtered/BD_filtered_DEL_224_sorted.txt", header = TRUE)
colnames(df.226) <- c("chr", "start", "end", "length", "c", "n","m","o","p" )

df.226$chr <-  factor(df.226$chr, levels= c(1:24))
ggplot(df.226, aes(x=length, fill=chr))+
  geom_density(alpha=0.40) + 
  scale_x_continuous(limits = c( 000,8000)) + 
  theme_bw() +
  


# df.all <-  read.table("BD_filtered_DEL_3642_sorted.txt", header = TRUE)
# colnames(df.all) <- c("chr", "start", "end", "length", "c", "n","m","o","p" )
# 
# df.all$chr <-  factor(df.all$chr, levels= c(1:22,"X","Y","M"))
# ggplot(df.all, aes(x=length, fill=chr))+
#   geom_density(alpha=0.40) + 
#   scale_x_continuous(limits = c( 500,8000)) + 
#   theme_bw()
# 


library(IRanges)

start <- df.some$Pos1
end <- df.some$Pos2

x <- IRanges(start=start, end=end)
cov <- coverage(x)
# plot coverage
plot(cov, type = "l"  , xlab = "position",   ylab = "frequency of gaps", main = "Coverage ")

## Genomestrip data
df.gs <-  read.table("../../genomestrip/gs_cnv.reduced.genotypes.txt", header = TRUE)
colnames(df.gs) <- c("chr", "start", "end", "name", "length")
df.gs$DELfreq <- rowSums(df.gs == 0)

gs.reduce <- df.gs[,c("chr", "start", "end", "name", "length", "DELfreq")]
gs.dels <- gs.reduce[!(gs.reduce$DELfreq==0),]

# one line per record - factors in duplications
gs.dels.expanded <- gs.dels[rep(row.names(gs.dels), gs.dels$DELfreq), 1:6]


ggplot(gs.dels.expanded, aes(x=length)) +
  geom_density(alpha=0.20) + 
  scale_x_continuous(limits = c(0000, 10000)) + 
  theme_bw()

ggplot(gs.dels, aes(x=length)) +
  geom_density(alpha=0.20) + 
  scale_x_continuous(limits = c(0000, 10000)) + 
  theme_bw()
