# bsub -o /nfs/team151/bh10/scripts/bh10_general/output/get_insertion_sizes-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/get_insertion_sizes-%J.err -R"select[mem>20000] rusage[mem=20000]" -M20000  R CMD BATCH /nfs/team151/bh10/scripts/bh10_general/multi_density.R

library("ggplot2", "/nfs/team151/software/Rlibs/")

d <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files/test", full.names=TRUE) # Lists files in the DIR
fn <- dir("/lustre/scratch115/projects/interval_wgs/analysis/sv/inserts/crams/files/test")

## Assemble a df from all samples
df.inserts <- data.frame()

for (i in 1:length(d))  {
  print(i)
  df.inserts.load <- data.frame(c(scan(d[i])), fn[i])
  colnames(df.inserts.load) <- c("insLength", "sample")
  df.inserts <- rbind(df.inserts, df.inserts.load)
}  

# Plot all samples on the sample plot
pdf("/nfs/team151/bh10/scripts/breakdancer_bh10/insert_size_distribution_test.pdf", width=10, height=8, pointsize=12, onefile=TRUE)
ggplot(df.inserts, aes(x=insLength, fill=sample)) +
  geom_density(alpha=0.25) + 
  scale_x_continuous(limits = c(0, 1000)) + 
  theme_bw()
dev.off()


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



