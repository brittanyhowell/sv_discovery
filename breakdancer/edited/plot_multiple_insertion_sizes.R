setwd("~/Documents/Rotation3/scripts/breakdancer/testInserts/")



d <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files", full.names=TRUE) # Lists files in the DIR
fn <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files")



## MAKE A DF M8
df.inserts <- data.frame()

for (i in 1:length(d))  {
  print(i)
  df.inserts.load <- data.frame(c(scan(d[i])), fn[i])
  colnames(df.inserts.load) <- c("insLength", "sample")
  df.inserts <- rbind(df.inserts, df.inserts.load)
}  


pdf("insert_size_distribution_test.pdf", width=10, height=8, pointsize=12, onefile=TRUE)
ggplot(df.inserts, aes(x=insLength, fill=sample)) +
  geom_density(alpha=0.25) + 
  scale_x_continuous(limits = c(0, 1000))
dev.off()



# pdf("insert_size_distribution_test_boxplot.pdf", width=10, height=10, pointsize=12, onefile=TRUE)
# par(mfrow=c(3,3), mai=c(0.6,0.6,0.5,0.1))
# 
# for (i in 1:length(fn))  {
#   par(mfrow=c(3,3), mai=c(0.6,0.6,0.5,0.1))
#   sep.df.inserts <- subset(df.inserts,df.inserts$sample==fn[i])
#   num <- i
#   p_num <- ggplot(sep.df.inserts,aes(x=sample, y=insLength)) +
#     geom_boxplot() + 
#     scale_y_continuous(limits = c(0, 1000))
# 
# }
# 
# dev.off()
# 
# multiplot(p1, p2, p3, p4, p5, p6, p7, p8, cols=4)




# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


 
