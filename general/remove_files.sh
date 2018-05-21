#!/bin/bash

# provide list of files, and DIR, and those files will be removed. 


listFiles=/lustre/scratch115/projects/interval_wgs/WGbams/poor_quality_samples.list
ext=".out"
fileDIR=/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/out/WG_3724


while read f; do
  filename=$f$ext
  echo "removing: ${filename}"
  rm ${fileDIR}/$filename
done <$listFiles

echo "purge complete"

