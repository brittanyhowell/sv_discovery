# This script splits the CNV or other genotyped data into one column per output. For use in intersect. 

# Number of columns: 
numCol=$(head -n1  GS_filtered_DEL_CNV.txt | awk --field-separator="\t" "{ print NF }" )
echo ${numCol}

for (( i = 6; i < ${numCol}; i++ )); do
	awk  -v i="$i"  '{print $1 "\t" $2 "\t" $3 "\t" $i}' GS_filtered_DEL_CNV.txt > tempName-${i}.txt



	# Replace some of the awkwardness in the header.
	head -n1 tempName-${i}.txt | sed 's/X.1.//g' | sed 's/X.2.//g' | sed 's/X.3.//g' | sed 's/.CN//g' > head.txt
	
	# get filename, improve it. 
	filename=$(head -n1 tempName-${i}.txt | awk '{print $4}' | awk -F'[.]' '{print $3}')
	echo $filename


	# Is it a DEL? make it better
	awk '{if ($4==0 || $4==1 ) print $0}'  tempName-${i}.txt >  body-temp-${i}.txt
	cat head.txt body-temp-${i}.txt > GS_filtered_DEL_CNV_${filename}.txt 

	rm tempName-${i}.txt
	rm body-temp-${i}.txt
done


