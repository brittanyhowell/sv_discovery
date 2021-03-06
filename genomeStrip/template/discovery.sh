#!/bin/bash

cohortId=$1
bamFileList=$2

export PATH=/software/hgi/pkglocal/samtools-1.3.1/bin:$PATH
export PATH=/software/R-3.0.0/bin:$PATH
export PATH=/software/java/bin/:$PATH

export LSF_DRMAA_CONF=/software/hgi/pkglocal/lsf-drmaa-1.1.1-lsf-9.1/etc/lsf_drmaa.conf

export SV_DIR= #######path to sv toolkit eg /software/page/svtoolkit
SV_CLASSPATH="${SV_DIR}/lib/SVToolkit.jar:${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar:${SV_DIR}/lib/gatk/Queue.jar"

echo $(date +"[%b %d %H:%M:%S] Extracting Genome STRiP reference bundle")
referenceFile= ######path to reference fuile, copy from "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta"
echo "Reference FASTA: "$referenceFile

wDir= ### path to your working dir
SV_TMPDIR=${wDir}/tmp
mkdir -p ${SV_TMPDIR}
runDir=${wDir}/del_output
mkdir -p ${runDir}
mkdir -p ${runDir}/logs || exit 1

metaData= #### path to your metadata dir 

filePrefix=gs_dels

echo "Running Deletion discovery pipeline..."

# Run discovery
java -cp ${SV_CLASSPATH} -Xmx2g \
    org.broadinstitute.gatk.queue.QCommandLine \
    -S ${SV_DIR}/qscript/SVDiscovery.q \
    -S ${SV_DIR}/qscript/SVQScript.q \
    -gatk ${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar \
    --disableJobReport \
    -cp ${SV_CLASSPATH} \
    -configFile ${SV_DIR}/conf/genstrip_parameters.txt \
    -tempDir ${SV_TMPDIR} \
    -R ${referenceFile} \
    -md ${metaData} \
    -jobRunner Drmaa \
    -gatkJobRunner Drmaa \
    -jobNative "-q long" \
    -jobNative "-R \"select[mem>10000] rusage[mem=10000]\"" \
    -jobNative "-M 10000" \
    -runDirectory ${runDir} \
    -jobLogDir ${runDir}/logs \
    -windowSize 5000000 \
    -windowPadding 10000 \
    -minimumSize 100 \
    -maximumSize 100000 \
    -I ${bamFileList} \
    -O ${runDir}/${filePrefix}.sites.vcf \
    -run \
    || exit 1

echo "Deletion discovery pipeline completed successfully"

tar -cvzf del_output.${cohortId}.tar.gz ${runDir} || exit 1

echo $(date +"[%b %d %H:%M:%S] Discovery completed successfully")
