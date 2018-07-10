bd.226 <-  read.table("/Users/bh10/Documents/Rotations/Rotation3/data/BD/filtered/BD_filtered_DEL_224_sorted.txt", header = TRUE)

bd.226$ConfidenceScore

ggplot(bd.226, aes(x=numReadPairs))+
  geom_density(alpha=0.80) + 
  theme_bw() 

pdf("~/dens_plot.pdf",width = 10, height = 3)
ggplot(sv.DEL, aes(x=numReadPairs))+
  geom_density(alpha=0.80) +
  scale_x_continuous( breaks = c(5,10,15,20,25,30,35), limits = c(0, )) + 
  theme_bw() 
graphics.off()


df.226$ReadPairs <- "ReadPairs"

ggplot(bd.226, aes(x=numReadPairs, y=ConfidenceScore)) +
  geom_point() + 
  theme_bw()

ggplot(bd.226, aes(x=1,y=numReadPairs)) +
  geom_boxplot(fill = "#56B4E9") +
  scale_fill_brewer(palette="Dark2") +
  xlab("Number of readpairs") +
  scale_y_continuous( breaks = c(2,4,6,8,10,12,14,16,18,20)) +
  theme_bw()
  
pdf("~/plot.R",width = 5, height = 5)
ggplot(sv.DEL, aes(x=1,y=numReadPairs)) +
  geom_boxplot(fill = "#56B4E9") +
  scale_fill_brewer(palette="Dark2") +
  xlab("Number of readpairs") +
  theme_bw()
graphics.off()


p1 = qplot(x = 1, y = numReadPairs, data = df.226, geom = 'boxplot', xlab = '') + 
  scale_colour_continuous(guide = FALSE) +
  scale_y_continuous( breaks = c(2,4,6,8,10,12,14,16,18,20,22)) +
  coord_flip() +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

p2 = qplot(x = numReadPairs, data = df.226, geom = 'density', xlab = '', ylab = '', main = "Number of readpairs supporting DELs in 224 BD samples")

plot_grid(p2, p1, align = "h", nrow = 2, rel_heights = c(2/3, 1/3))

