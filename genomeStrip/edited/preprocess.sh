#!/bin/bash

cohortId=$1
bamFileList=$2

export PATH=/software/hgi/pkglocal/samtools-1.3.1/bin:$PATH
export PATH=/software/R-3.0.0/bin:$PATH
export PATH=/software/java/bin/:$PATH

export LSF_DRMAA_CONF=/software/hgi/pkglocal/lsf-drmaa-1.1.1-lsf-9.1/etc/lsf_drmaa.conf

export SV_DIR=/nfs/team151/software/svtoolkit  ### path to svtoolkit eg /software/page/svtoolkit
SV_CLASSPATH="${SV_DIR}/lib/SVToolkit.jar:${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar:${SV_DIR}/lib/gatk/Queue.jar"

echo $(date +"[%b %d %H:%M:%S] Extracting Genome STRiP reference bundle")
# referenceFile=/lustre/scratch115/projects/interval_wgs/analysis/sv/genomes/hs38DH.fa ###path to reference file copy from "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta"
referenceFile=/lustre/scratch115/realdata/mdt1/projects/interval_wgs/analysis/gatk/Homo_sapiens_assembly38/Homo_sapiens_assembly38.fasta ###path to reference file copy from "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta"
echo "Reference FASTA: "$referenceFile


wDir=/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/preprocess_WC
ploidyFile=/nfs/team151/bh10/scripts/genomestrip_bh10/human_ploidy_map_GRCh38.txt 
tmpDir=${wDir}/tmp
metaDataDir=${wDir}/metadata
logDir=${metaDataDir}/logs

mkdir -p ${tmpDir}
mkdir -p ${metaDataDir}
mkdir -p ${logDir}

echo $(date +"[%b %d %H:%M:%S] Starting preprocessing")

java -cp ${SV_CLASSPATH} -Xmx9g \
    org.broadinstitute.gatk.queue.QCommandLine \
    -S ${SV_DIR}/qscript/SVPreprocess.q \
    -S ${SV_DIR}/qscript/SVQScript.q \
    -configFile ${SV_DIR}/conf/genstrip_parameters.txt \
    -tempDir ${tmpDir} \
    -gatk ${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar \
    -cp ${SV_CLASSPATH} \
    -jobRunner Drmaa \
    -gatkJobRunner Drmaa \
    -jobNative "-q normal" \
    -jobNative "-R \"select[mem>10000] rusage[mem=10000]\"" \
    -jobNative "-M 10000" \
    -jobLogDir ${logDir} \
    -R ${referenceFile} \
    -ploidyMapFile ${ploidyFile} \
    -md ${metaDataDir} \
    -I ${bamFileList} \
    -bamFilesAreDisjoint true \
    -reduceInsertSizeDistributions true \
    -deleteIntermediateDirs true \
    -run \
    || exit 1

echo $(date +"[%b %d %H:%M:%S] Archiving metadata directory")
tar -cvzf ${cohortId}.tar.gz ${metaDataDir} || exit 1

echo $(date +"[%b %d %H:%M:%S] Preprocessing completed successfully")

