#!/bin/bash

bamFileList=$1

export PATH=/software/hgi/pkglocal/samtools-1.3.1/bin:$PATH
export PATH=/software/R-3.0.0/bin:$PATH
export PATH=/software/java/bin/:$PATH
export LSF_DRMAA_CONF=/software/hgi/pkglocal/lsf-drmaa-1.1.1-lsf-9.1/etc/lsf_drmaa.conf

export SV_DIR= ######### path to svtoolkit eg/software/page/svtoolkit
SV_CLASSPATH="${SV_DIR}/lib/SVToolkit.jar:${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar:${SV_DIR}/lib/gatk/Queue.jar"

echo $(date +"[%b %d %H:%M:%S] Extracting Genome STRiP reference bundle")
referenceFile= ####path to reference file copy this from "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta"
echo "Reference FASTA: "$referenceFile

wDir= ######path to your working dir
mdPath=${wDir}/metadata_old
SV_TMPDIR=${wDir}/tmp

genderMapFile=${wDir}/profiles_10000/sample_gender.report.txt

runDir=${wDir}/cnv_output

java -Xmx4g -cp ${SV_CLASSPATH} \
     org.broadinstitute.gatk.queue.QCommandLine \
     -S ${SV_DIR}/qscript/discovery/cnv/CNVDiscoveryPipeline.q \
     -S ${SV_DIR}/qscript/SVQScript.q \
     -cp ${SV_CLASSPATH} \
     -gatk ${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar \
     -configFile ${SV_DIR}/conf/genstrip_parameters.txt \
     -R ${referenceFile} \
     -I ${bamFileList} \
     -genderMapFile ${genderMapFile} \
     -md ${mdPath} \
     -runDirectory ${runDir} \
     -jobRunner Drmaa \
     -gatkJobRunner Drmaa \
     -jobNative "-q long" \
     -jobNative "-R \"select[mem>10000] rusage[mem=10000]\"" \
     -jobNative "-M 10000" \
     -jobLogDir ${runDir}/logs \
     -tilingWindowSize 1000 \
     -tilingWindowOverlap 500 \
     -maximumReferenceGapLength 1000 \
     -boundaryPrecision 100 \
     -minimumRefinedLength 500 \
     -tempDir ${SV_TMPDIR} \
     -run || exit 1
