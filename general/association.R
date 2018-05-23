args = commandArgs(TRUE)

outTable <- "/lustre/scratch115/projects/interval_wgs/analysis/sv/association/association_coefficients_CNV.txt"

## read in phenotype table
pheno <- read.table("/lustre/scratch115/projects/interval_wgs/analysis/phenotypes/FBC_223-samples.txt", header = TRUE)
phenCols <- colnames(pheno)
rownames(pheno) <- pheno$ID
pheno <- subset(pheno, select=-ID)

cnv.file <- args[1]

# Read in reordered table
cnv.table <- read.table(file = cnv.file, header = T)
rownames(cnv.table) <- cnv.table$Exon
cnv.table <- subset(cnv.table, select=-Exon)

# loop over me
oneSample <- as.integer(cnv.table[1,])

## So, loop over each row of the CNV data (each gene), use that as the input vector.

# coef <- NULL 
# for (i in 1:nrow(cnv.table)){ lm function, rbind to df. }


coef <-  as.data.frame(apply(cnv.table,1,function(j) coefficients <-  t(apply(pheno, 2, function(x)  summary(lm(as.integer((j)) ~ x))$coefficients[2,1] )) ))

coef <- cbind(phenCols,coef)

# rbind(coef, coefficients)


 write.table(coef, outTable, quote=F, row.names=F,  sep="\t")
