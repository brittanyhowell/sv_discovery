# bsub -o /nfs/team151/bh10/scripts/bh10_general/output/get_insertion_sizes-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/get_insertion_sizes-%J.err -R"select[mem>1000] rusage[mem=1000]" -M1000  /software/R-3.4.0/bin/R CMD BATCH /nfs/team151/bh10/scripts/bh10_general/multi_density.R
.libPaths( c( .libPaths(), "/nfs/team151/software/Rlibs/") )


library("ggplot2", lib.loc="/nfs/team151/software/Rlibs/")
library("stringi", lib.loc="/nfs/team151/software/Rlibs/")

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
  
   if(i %% 10 == 0 | i == length(d)){
    # Name the PDF
    name <- paste("/nfs/team151/bh10/scripts/bh10_general/plots/insert_size_dist_dens", plot.num, sep = "_")
    # name <- paste("/Users/bh10/Documents/Rotation3/data/inserts/test_insert_dist", plot.num, sep = "_")
    name <- paste(name, "pdf", sep = ".")
    # generate a plot from those 10
    
    pdf(name, width=10, height=10, pointsize=12, onefile=TRUE)
   
      print(ggplot(df.inserts, aes(x=insLength, fill=sample)) +
      geom_density(alpha=0.20) + 
      scale_x_continuous(limits = c(0, 1000)) + 
      theme_bw())
    
    dev.off()
    
    boxname <- paste("/nfs/team151/bh10/scripts/bh10_general/plots/insert_size_dist_box", plot.num, sep = "_")
    # boxname <- paste("/Users/bh10/Documents/Rotation3/data/inserts/test_insert_box", plot.num, sep = "_")
    boxname <- paste(boxname, "pdf", sep = ".")
    # generate a boxplot from those 10
    pdf(boxname, width=15, height=10, pointsize=12, onefile=TRUE)
     print(ggplot(df.inserts,aes(x=sample, y=insLength, fill=sample)) +
      geom_boxplot() +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 10, hjust = 1), legend.position = "none")+
        ylab("Insert size")+
        xlab("") +
      scale_y_continuous(limits = c(0, 1000)))
    dev.off()
 
    boxname.unlimited <- paste("/nfs/team151/bh10/scripts/bh10_general/plots/insert_size_dist_box_limitless", plot.num, sep = "_")
    # boxname.unlimited <- paste("/Users/bh10/Documents/Rotation3/data/inserts/test_insert_limitlessbox", plot.num, sep = "_")
    boxname.unlimited <- paste(boxname.unlimited, "pdf", sep = ".")
    # generate a boxplot from those 10
    pdf(boxname.unlimited, width=15, height=10, pointsize=12, onefile=TRUE)
    print(ggplot(df.inserts,aes(x=sample, y=insLength, fill=sample)) +
      geom_boxplot() +
        theme_bw()+
        theme(axis.text.x = element_text(angle = 10, hjust = 1), legend.position = "none")+
        ylab("Insert size")+
        xlab("") )
    dev.off() 
    

    
    #reset the df
    df.inserts <- data.frame()
    plot.num <- plot.num + 1
   }
  
}  
