# analyse filtered BD output


library(ggplot2)


setwd("/Users/bh10/Documents/Rotation3/data/BD/filtered")
df.sub <-  read.table("BD_filtered_DEL_3642_sorted_10000.txt", header = TRUE)



ggplot(dfsub, aes(x=SizeSV, fill=Chr1)) +
  geom_density(alpha=0.20) + 
  scale_x_continuous(limits = c(0, 1000)) + 
  theme_bw()


df.all <-  read.table("BD_filtered_DEL_3642_sorted.txt", header = TRUE)
colnames(df.all) <- c("chr", "start", "end", "length", "c", "n","m","o","p" )

df.all$chr <-  as.character(df.all$chr)
ggplot(df.all, aes(x=length, fill=chr))+
  geom_density(alpha=0.40) + 
  scale_x_continuous(limits = c( 3000,7000)) + 
  theme_bw()


df.some <-  read.table("BD_filtered_DEL_3642_sorted_100000.txt", header = TRUE)
colnames(df.some) <- c("chr", "start", "end", "length", "c", "n","m","o","p" )
ggplot(df.some, aes(x=length, fill=chr)) +
  geom_density(alpha=0.20) + 
  scale_x_continuous(limits = c(0, 30000)) + 
  theme_bw()


ggplot(data=df.some, aes(x=Pos1, y=Pos2)) +
  geom_line(x=x, y=1) + 
  scale_x_continuous(limits = c(0, 30000)) + 
  theme_bw()


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
