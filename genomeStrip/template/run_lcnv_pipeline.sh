#!/bin/bash

sampleList=$1
#profilesArchive=$2 ###no need to supply profiles archive this time as unextracted version exists

export PATH=/software/hgi/pkglocal/samtools-1.3.1/bin:$PATH
export PATH=/software/R-3.0.0/bin:$PATH
export PATH=/software/java/bin/:$PATH

export LSF_DRMAA_CONF=/software/hgi/pkglocal/lsf-drmaa-1.1.1-lsf-9.1/etc/lsf_drmaa.conf

export SV_DIR= ### path to svtoolkit eg /software/page/svtoolkit
SV_CLASSPATH="${SV_DIR}/lib/SVToolkit.jar:${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar:${SV_DIR}/lib/gatk/Queue.jar"

echo $(date +"[%b %d %H:%M:%S] Extracting Genome STRiP reference bundle")
referenceFile= ### path to reference file copy from "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta"
  echo "Reference FASTA: "$referenceFile

wDir= ### path to your working dir 
profilesDir=${wDir}/profiles_10000
#mkdir -p ${profilesDir} || exit 1 

#tar -xvzf ${profilesArchive} --strip-components 1 -C ${profilesDir} || exit 1

genderMapFile=${profilesDir}/sample_gender.report.txt
runDir=${wDir}/lcnv_calls
logDir=${runDir}/logs
mkdir -p ${logDir} || exit 1

# Progressive scan
maxDepth=50
binSize=10000

echo $(date +"[%b %d %H:%M:%S] Running LCNV pipeline")

java -cp ${SV_CLASSPATH} -Xmx4g \
    org.broadinstitute.gatk.queue.QCommandLine \
    -S ${SV_DIR}/qscript/discovery/lcnv/LCNVDiscoveryPipeline.q \
    -S ${SV_DIR}/qscript/SVQScript.q \
    -gatk ${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar \
    -cp ${SV_CLASSPATH} \
    -jobLogDir ${logDir} \
    -R ${referenceFile} \
    -profilesDir ${profilesDir} \
    -maxDepth ${maxDepth} \
    -perSampleScan true \
    -sample ${sampleList} \
    -backgroundSample ${sampleList} \
    -genderMapFile ${genderMapFile} \
    -runDirectory ${runDir} \
    -jobRunner Drmaa \
    -gatkJobRunner Drmaa \
    -jobNative "-q long" \
    -jobNative "-R \"select[mem>10000] rusage[mem=10000]\"" \
    -jobNative "-M 10000" \
    -run \
    || exit 1

echo $(date +"[%b %d %H:%M:%S] Archiving lcnv_calls directory")
tar -cvzf lcnv_calls.tar.gz ${runDir}

echo $(date +"[%b %d %H:%M:%S] LCNV pipeline completed successfully")
