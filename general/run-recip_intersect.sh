#!/bin/bash

# bsub  -o /nfs/team151/bh10/scripts/bh10_general/output/intersects/intersect-%J.out -e /nfs/team151/bh10/scripts/bh10_general/output/intersects/intersect-%J.err -R"select[mem>1000] rusage[mem=1000]" -M1000 /nfs/team151/bh10/scripts/bh10_general/run-recip_intersect_per_sample.sh

echo "commence"
scriptDIR=/nfs/team151/bh10/scripts/bh10_general/


sampleList=/nfs/team151/bh10/scripts/bh10_general/fileLists/226Samples.list


BDDir="/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642_XY/226subset" 
GSDir="/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/filtered_sv/split_tables_CNV_genotyped"

outDIR="/lustre/scratch115/projects/interval_wgs/analysis/sv/intersects/sampleIntersect/"
sumOut="${outDIR}/sum_intersect_BD_CNV.txt"
rm ${sumOut}
touch ${sumOut}

printf '%s\t%s\t%s\t%s\t%s\t%s\n' "sample" "uniqBD" "uniqGS" "intersect" "rawBD" "rawGS">> ${sumOut}


echo "run intersect for each sample"


while read p; do

	sampleBD="BD_filtered_DEL_${p}"
	sampleGS="GS_filtered_DEL_CNV_${p}"

	fileBD=${BDDir}/${sampleBD}
	fileGS=${GSDir}/${sampleGS}

	linesBD=$(cat ${fileBD}|wc -l )
	linesGS=$(cat ${fileGS}|wc -l )

	if [[ -f ${fileBD} && ${fileGS} ]]; then
		
		out="intersect_${p}"

		echo "command:  go run ${scriptDIR}/recip_intersect.go -oneIn=${fileBD} -twoIn=${fileGS} -outPath=${outDIR} -out=${out}"
		go run ${scriptDIR}/recip_intersect.go -oneIn=${fileBD} -twoIn=${fileGS} -outPath=${outDIR} -out=${out}

		
		cd ${outDIR}
		uniqA=$(cat ${out}| awk '{print $1"-"$2":"$3}' | sort | uniq | wc -l )
		uniqB=$(cat ${out}| awk '{print $5"-"$6":"$7}' | sort | uniq | wc -l )
		all=$(cat ${out} | wc -l)



		
		printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$p" "${uniqA}" "${uniqB}" "${all}" "${linesBD}" "${linesGS}">> ${sumOut}

	else
	    echo "one of your files did not exist, it has been skipped."
	fi



done <${sampleList}


echo "complete"



#"/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/filtered_sv/GS_filtered_DEL_disc.txt"
#"/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/filtered_sv/GS_filtered_DEL_CNV_no_genotype_info.txt"
#"/lustre/scratch115/projects/interval_wgs/analysis/sv/breakdancer/filtered/WG_3642_XY/BD_filtered_DEL_224_sorted.txt"


# /lustre/scratch115/projects/interval_wgs/analysis/sv/intersects/intersect_GS_disc_CNV.txt



