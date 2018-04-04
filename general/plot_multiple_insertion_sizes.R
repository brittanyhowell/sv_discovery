# bsub -o /nfs/team151/bh10/scripts/bh10_general/output/get_insertion_sizes-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/get_insertion_sizes-%J.err -R"select[mem>20000] rusage[mem=20000]" -M20000  R CMD BATCH /nfs/team151/bh10/scripts/bh10_general/multi_density.R
.libPaths( c( .libPaths(), "/nfs/team151/software/Rlibs/") )


library("ggplot2", "/nfs/team151/software/Rlibs/")

d <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files", full.names=TRUE) # Lists files in the DIR
fn <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files")

## Assemble a df from all samples
df.inserts <- data.frame()
plot.num <- 1

for (i in 1:length(d))  {
  print(i)
  df.inserts.load <- data.frame(c(scan(d[i])), fn[i])
  colnames(df.inserts.load) <- c("insLength", "sample")
  df.inserts <- rbind(df.inserts, df.inserts.load)
  
  if(i %% 10 == 0 | i == length(d)){
    # Name the PDF
    name <- paste("/nfs/team151/bh10/scripts/bh10_general/insert_size_distribution", plot.num, "pdf", sep = ".")
    # generate a plot from those 10
    pdf(name, width=10, height=8, pointsize=12, onefile=TRUE)
    ggplot(df.inserts, aes(x=insLength, fill=sample)) +
      geom_density(alpha=0.20) + 
      scale_x_continuous(limits = c(0, 1000)) + 
      theme_bw()
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



