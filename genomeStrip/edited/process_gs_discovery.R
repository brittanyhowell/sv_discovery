# # DIRs
file.DIR <- "/Users/bh10/Documents/Rotations/Rotation3/data/genomestrip/discovery/"
out.DIR <- "/Users/bh10/Documents/Rotations/Rotation3/data/genomestrip/discovery/"


# Sample
## Make sure sample table doesn't have a # symbol at the start of the header line
sample.name.ext <- paste(file.DIR,"GS_filtered_DEL_disc.txt" , sep="/")


# Read table
df <- read.table("/Users/bh10/Documents/Rotations/Rotation3/data/genomestrip/discovery/226_discovery_genotypes.txt", fill = TRUE, header=TRUE, check.names = FALSE)
