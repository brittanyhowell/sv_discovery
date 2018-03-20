#!/bin/bash

cohortId=$1
bamFileList=$2

export PATH=/software/hgi/pkglocal/samtools-1.3.1/bin:$PATH
export PATH=/software/R-3.0.0/bin:$PATH
export PATH=/software/java/bin/:$PATH

export LSF_DRMAA_CONF=/software/hgi/pkglocal/lsf-drmaa-1.1.1-lsf-9.1/etc/lsf_drmaa.conf

export SV_DIR= ## path to svtoolkit eg /software/page/svtoolkit
SV_CLASSPATH="${SV_DIR}/lib/SVToolkit.jar:${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar:${SV_DIR}/lib/gatk/Queue.jar"

referenceFile=  ### path to reference - copy from "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta"

# Filter calls in alpha-satellite regions
wDir= #### path to working dir
SV_TMPDIR=${wDir}tmp
mkdir -p ${SV_TMPDIR}
runDir=${wDir}/del_output
filtDir=${runDir}/filtering
mkdir -p ${filtDir} || exit 1

mdPath=${wDir}/metadata

filePrefix=gs_dels

# Use hg19 repeats but with sequence names like "1" vs. "chr1"
repeatTrackFile=${wDir}/ucsc_repeats_g1k_v37.dat

java -cp ${SV_CLASSPATH} -Xmx4g \
    org.broadinstitute.sv.main.SVAnnotator \
    -R ${referenceFile} \
    -A MobileElements \
    -repeatTrackFile ${repeatTrackFile} \
    -vcf ${runDir}/${filePrefix}.sites.vcf \
    -O ${filtDir}/${filePrefix}.annotated.sites.vcf \
    || exit 1

# Filter to select passing variants with acceptably low alpha-satellite fraction

#vcfextract -fields ID,FILTER,INFO:GSALPHASATFRACTION ${filtDir}/${filePrefix}.annotated.sites.vcf > ${filtDir}/${filePrefix}.info.dat || exit 1
#cat ${filtDir}/${filePrefix}.info.dat | awk '$2 == "PASS" && $3 < 0.5 { print $1 }' > ${filtDir}/${filePrefix}.sites.list || exit 1
java -Xmx1g -cp ${SV_CLASSPATH} org.broadinstitute.sv.apps.VCFExtract \
    -fields ID,FILTER,INFO:GSALPHASATFRACTION \
    ${filtDir}/${filePrefix}.annotated.sites.vcf \
    > ${filtDir}/${filePrefix}.info.dat || exit 1
cat ${filtDir}/${filePrefix}.info.dat | awk '$2 == "PASS" && $3 < 0.5 { print $1 }' > ${filtDir}/${filePrefix}.sites.list || exit 1

# Run genotyping on the selected variants

gtDir=${runDir}/genotyping
mkdir -p ${gtDir} || exit 1

#(cat ${runDir}/${filePrefix}.sites.vcf | grep ^#; \
# cat ${runDir}/${filePrefix}.sites.vcf | grep -v ^# | joinfiles -select - 3 ${filtDir}/${filePrefix}.sites.list 1) \
#    | bgzip -c > ${gtDir}/${filePrefix}.sites.vcf.gz || exit 1
#gunzip -c ${gtDir}/${filePrefix}.sites.vcf.gz | grep -v ^# | cut -f 3 > ${gtDir}/${filePrefix}.sites.list || exit 1

java -cp ${SV_CLASSPATH} -Xmx4g \
    org.broadinstitute.sv.apps.VCFFilter \
    -R ${referenceFile} \
    -vcf ${runDir}/${filePrefix}.sites.vcf \
    -includeSite ${filtDir}/${filePrefix}.sites.list \
    -O ${gtDir}/${filePrefix}.sites.vcf.gz \
    || exit 1

echo "Genotyping the selected variants..."

java -cp ${SV_CLASSPATH} -Xmx4g \
    org.broadinstitute.gatk.queue.QCommandLine \
    -S ${SV_DIR}/qscript/SVGenotyper.q \
    -S ${SV_DIR}/qscript/SVQScript.q \
    -gatk ${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar \
    --disableJobReport \
    -cp ${SV_CLASSPATH} \
    -configFile ${SV_DIR}/conf/genstrip_parameters.txt \
    -tempDir ${SV_TMPDIR} \
    -R ${referenceFile} \
    -runDirectory ${gtDir} \
    -md ${mdPath} \
    -jobLogDir ${runDir}/logs \
    -jobRunner Drmaa \
    -gatkJobRunner Drmaa \
    -jobNative "-q long" \
    -jobNative "-R \"select[mem>10000] rusage[mem=10000]\"" \
    -jobNative "-M 10000" \
    -memLimit 8 \
    -I ${bamFileList} \
    -parallelRecords 100 \
    -vcf ${gtDir}/${filePrefix}.sites.vcf.gz \
    -O ${gtDir}/${filePrefix}.genotypes.vcf.gz \
    -run \
    || exit 1

evalDir=${gtDir}/eval
mkdir -p ${evalDir} || exit 1

# Generate useful report files

#vcfextract -fields ID,CHROM,POS,INFO:END,INFO:GSELENGTH ${gtDir}/${filePrefix}.genotypes.vcf.gz \
#    | awk -v OFS="\t" '{ if (NR == 1) { $6 = "LENGTH"; $7 = "DENSITY" } else { $6 = $4-$3+1; $7 = sprintf("%1.4f", $5/$6) }; print }' \
#    > ${evalDir}/VariantLength.report.dat || exit 1

echo "Generating reports..."

java -Xmx1g -cp ${SV_CLASSPATH} org.broadinstitute.sv.apps.VCFExtract \
    -fields ID,CHROM,POS,INFO:END,INFO:GSELENGTH \
    ${gtDir}/${filePrefix}.genotypes.vcf.gz \
    | awk -v OFS="\t" '{ if (NR == 1) { $6 = "LENGTH"; $7 = "DENSITY" } else { $6 = $4-$3+1; $7 = sprintf("%1.4f", $5/$6) }; print }' \
    > ${evalDir}/VariantLength.report.dat || exit 1

auxFilePrefix="${gtDir}/${filePrefix}.genotypes"

auxFilePrefix="${gtDir}/${filePrefix}.genotypes"

java -cp ${SV_CLASSPATH} -Xmx4g \
    org.broadinstitute.sv.main.SVAnnotator \
        -R ${referenceFile} \
        -vcf ${gtDir}/${filePrefix}.genotypes.vcf.gz \
        -auxFilePrefix ${auxFilePrefix} \
        -A CopyNumberClass \
        -A ClusterSeparation \
        -A VariantsPerSample \
        -A GCContent \
        -writeReport true \
        -writeSummary true \
        -reportDirectory ${evalDir} \
        || exit 1

cat ${evalDir}/VariantsPerSample.report.dat | cut -f 1 | tail -n +2 > ${runDir}/samples.list || exit 1

echo "Deletion discovery pipeline completed successfully"

tar -cvzf del_output.tar.gz ${runDir} || exit 1
