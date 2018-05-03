#!/bin/bash

## Merge dfs made in BD-analyse.R


## Make sure the prefix is right, and you adjust the output name

 { head -n1 head1; for f in BD_filtered_DEL_*; do tail -n+2 "$f"; done; } > BD_filtered_DEL_3642.txt

## Use the following to sort the file
cat BD_filtered_DEL_3642.txt | awk 'NR == 1; NR > 1 {print $0 | "sort -n -k1,1 -k2,2"}' > BD_filtered_DEL_3642_sorted.txt