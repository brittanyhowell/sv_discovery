#!/bin/bash


for f in *.fa* ; do 

	echo "replacing in $f"
	
	sed 's/\*/_/g' ${f} > ${f}_tmp

	echo "renaming ${f}"
	mv ${f}_tmp ${f}

done

echo "complete"