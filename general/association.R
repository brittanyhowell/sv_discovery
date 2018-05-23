setwd("~/Documents/Rotation3/data/")

outTable <- "phenotypes/association_coefficients_CNV.txt"

## read in phenotype table
pheno <- read.table("phenotypes/FBC_223-samples.txt", header = TRUE)
rownames(pheno) <- pheno$ID
pheno <- subset(pheno, select=-ID)

onepheno <-subset(pheno, select = 1)



# Read in reordered table
cnv.table <- read.table(file = "/Users/bh10/Documents/Rotation3/data/geneIntersect/small-merged-GS-CNV-ordered.txt", header = T)
rownames(cnv.table) <- cnv.table$Exon
cnv.table <- subset(cnv.table, select=-Exon)

# loop over me
oneSample <- as.integer(cnv.table[1,])

## So, loop over each row of the CNV data (each gene), use that as the input vector.

# coef <- NULL 
# for (i in 1:nrow(cnv.table)){ lm function, rbind to df. }


df <-  apply(cnv.table,1,function(j) coefficients <-  t(apply(pheno, 2, function(x)  summary(lm(as.integer((j)) ~ x))$coefficients[2,1] )) )

# rbind(coef, coefficients)


# write.table(coef, outTable) 



