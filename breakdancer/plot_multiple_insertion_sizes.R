setwd("~/Documents/Rotation3/scripts/breakdancer/testInserts/")



d <- dir("~/Documents/Rotation3/scripts/breakdancer/testInserts/", full.names=TRUE) # Lists files in the DIR
fn <- dir("~/Documents/Rotation3/scripts/breakdancer/testInserts/")
pdf("insert_size_distribution_test.pdf", width=10, height=10, pointsize=12, onefile=TRUE)

df <- data.frame()
par(mfrow=c(3,3), mai=c(0.6,0.6,0.5,0.1))
for (i in 1:length(d))  {
  print(i)
  f <- scan(d[i])
# df$i <-  NA
# df <-  data.frame(matrix(unlist(f), byrow=T))
df$i <- data.frame(matrix(unlist(f), byrow=T))
  
  
  #plot(density(f, from=0, to=1000), col="blue", main=fn[i])
}
dev.off()



y <- matrix(rnorm(100), 10, 10)
require(reshape2)

y_m <- melt(y)

require(ggplot2)
ggplot() +
  geom_line(data = f, aes(x = Var1, y = value, group = Var2))

