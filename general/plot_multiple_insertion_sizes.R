# bsub -o /nfs/team151/bh10/scripts/bh10_general/output/get_insertion_sizes-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/get_insertion_sizes-%J.err -R"select[mem>1000] rusage[mem=1000]" -M1000  R CMD BATCH /nfs/team151/bh10/scripts/bh10_general/multi_density.R
.libPaths( c( .libPaths(), "/nfs/team151/software/Rlibs/") )


library("ggplot2", "/nfs/team151/software/Rlibs/")

d <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files", full.names=TRUE) # Lists files in the DIR
fn <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files")

# d <- dir("/Users/bh10/Documents/Rotation3/scripts/breakdancer/testInserts", full.names=TRUE) # Lists files in the DIR
# fn <- dir("/Users/bh10/Documents/Rotation3/scripts/breakdancer/testInserts")

## Assemble a df from all samples
df.inserts <- data.frame()
plot.num <- 1

for (i in 1:length(d))  {
  print(i)
  df.inserts.load <- data.frame(c(scan(d[i])), fn[i])
  colnames(df.inserts.load) <- c("insLength", "sample")
  df.inserts <- rbind(df.inserts, df.inserts.load)
  
   if(i %% 5 == 0 | i == length(d)){
    # Name the PDF
    name <- paste("/nfs/team151/bh10/scripts/bh10_general/plots/insert_size_dist_dens", plot.num, "pdf", sep = ".")
    # name <- paste("/Users/bh10/Documents/Rotation3/data/inserts/test_insert_dist", plot.num, sep = "_")
    name <- paste(name, "pdf", sep = ".")
    # generate a plot from those 10
    pdf(name, width=10, height=8)
    
    print(ggplot(df.inserts, aes(x=insLength, fill=sample)) +
      geom_density(alpha=0.20) + 
      scale_x_continuous(limits = c(0, 1000)) + 
      theme_bw())
    
    dev.off()
    
    boxname <- paste("/nfs/team151/bh10/scripts/bh10_general/plots/insert_size_dist_box", plot.num, sep = "_")
    boxname <- paste(boxname, "pdf", sep = ".")
    # generate a boxplot from those 10
    pdf(boxname, width=10, height=8)
    print(ggplot(df.inserts,aes(x=sample, y=insLength, fill=sample)) +
      geom_boxplot() +
      scale_y_continuous(limits = c(0, 1000)))
    dev.off()
 
    boxname.unlimited <- paste("/nfs/team151/bh10/scripts/bh10_general/plots/insert_size_dist_box_limitless", plot.num, sep = "_")
    boxname.unlimited <- paste(boxname.unlimited, "pdf", sep = ".")
    # generate a boxplot from those 10
    pdf(boxname.unlimited, width=10, height=8)
    print(ggplot(df.inserts,aes(x=sample, y=insLength, fill=sample)) +
      geom_boxplot() )
    dev.off()   
    
    #reset the df
    df.inserts <- data.frame()
    plot.num <- plot.num + 1
   }
  
}  


# ## If statement testing
# 
# test <- c("4", "5", "6", "5", "6", "5", "6", "5", "6", "7")
# for (j in 1:length(test)){
#   if(j %% 3 == 0 | j == length(test)){
#     print(c(j, "div by 3 or 10"))}
#   print(j)
# 
# }

# # Plot all samples on the sample plot
# pdf("/nfs/team151/bh10/scripts/breakdancer_bh10/insert_size_distribution_test.pdf", width=10, height=8, pointsize=12, onefile=TRUE)
# ggplot(df.inserts, aes(x=insLength, fill=sample)) +
#   geom_density(alpha=0.10) + 
#   scale_x_continuous(limits = c(0, 1000)) + 
#   theme_bw()
# dev.off()


# She's broken:
# plot.name <- 
# 
# name <- paste("/Users/bh10/Documents/Rotation3/data/inserts/testBOX", plot.num, sep = "_")
# name <- paste(name, "pdf", sep = ".")
# # generate a plot from those 10
# 
# 
# 
# pdf(name, width=10, height=10, pointsize=12)
# par(mfrow=c(3,3), mai=c(0.6,0.6,0.5,0.1))
# 
# # for (i in 1:length(fn))  {
#   sep.df.inserts <- subset(df.inserts,df.inserts$sample==fn[i])
#   num <- i
#   plot.name <- paste("p",i, sep="")
#   # plot.name <- 
#     
# 
# # }
#   pdf(name, width=10, height=10, pointsize=12)
#   ggplot(df.inserts,aes(x=sample, y=insLength, fill=sample)) +
#     geom_boxplot() +
#     scale_y_continuous(limits = c(0, 1000))
#   
#   
# dev.off()
# 
# multiplot(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, cols=5)
# 
# 
# # Multiple plot function
# #
# # ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# # - cols:   Number of columns in layout
# # - layout: A matrix specifying the layout. If present, 'cols' is ignored.
# #
# # If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# # then plot 1 will go in the upper left, 2 will go in the upper right, and
# # 3 will go all the way across the bottom.
# #
# # 
# # 
# multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
#   library(grid)
# 
#   # Make a list from the ... arguments and plotlist
#   plots <- c(list(...), plotlist)
# 
#   numPlots = length(plots)
# 
#   # If layout is NULL, then use 'cols' to determine layout
#   if (is.null(layout)) {
#     # Make the panel
#     # ncol: Number of columns of plots
#     # nrow: Number of rows needed, calculated from # of cols
#     layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
#                      ncol = cols, nrow = ceiling(numPlots/cols))
#   }
# 
#   if (numPlots==1) {
#     print(plots[[1]])
# 
#   } else {
#     # Set up the page
#     grid.newpage()
#     pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
# 
#     # Make each plot, in the correct location
#     for (i in 1:numPlots) {
#       # Get the i,j matrix positions of the regions that contain this subplot
#       matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
# 
#       print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
#                                       layout.pos.col = matchidx$col))
#     }
#   }
# }
# 
# 
