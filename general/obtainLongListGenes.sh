## cat together all of the genes:

zcat chr*.gz | awk  '$5=="protein_coding"' > all_chr_protein_coding.txt