#!/bin/bash


outPath="/Users/bh10/Documents/Rotation3/scripts/general/" 
geneOut="geneList.txt" 
delIn="/Users/bh10/Documents/Rotation3/scripts/general/test_dels.txt" 
geneIn="/Users/bh10/Documents/Rotation3/scripts/general/test_genes.txt"



go run intersect_genes.go -outPath ${outPath} -geneOut ${geneOut} -delIn ${delIn} -geneIn ${geneIn}