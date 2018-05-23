setwd("~/Documents/Rotation3/data/")

outTable <- "phenotypes/association_coefficients_CNV.txt"

## read in phenotype table
pheno <- read.table("phenotypes/FBC_223-samples.txt", header = TRUE)
rownames(pheno) <- pheno$ID
pheno <- subset(pheno, select=-ID)

onepheno <-subset(pheno, select = 1)



# Read in reordered table
cnv.table <- read.table(file = "geneIntersect/tiny_geno_merge.txt", header = T)
rownames(cnv.table) <- cnv.table$Exon
cnv.table <- subset(cnv.table, select=-Exon)

# Lets pretend that this vector is a vector of 0s related to how each sample has a zero for this one gene, hey?
oneSample <- as.integer(cnv.table[1,])
# Reduce to 223 until I get the proper data in
oneSample <- head(oneSample, n=223)

## So, loop over each row of the CNV data (each gene), use that as the input vector.

# coef <- NULL 
# for (i in 1:nrow(cnv.table)){ lm function, rbind to df. }





coefficients <-  t(apply(pheno, 2, function(x)  summary(lm(oneSample ~ x))$coefficients[2,1] ))

# rbind(coef, coefficients)


# write.table(coef, outTable) 



