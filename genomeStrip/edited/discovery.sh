#!/bin/bash

cohortId=$1
echo "cohort ID: " $cohortId
bamFileList=/nfs/team151/bh10/scripts/genomestrip_bh10/fileLists/fileLists/WG_bam_filepath_two.list
echo "file list: "$bamFileList

export PATH=/software/hgi/pkglocal/samtools-1.3.1/bin:$PATH
export PATH=/software/R-3.0.0/bin:$PATH
export PATH=/software/java/bin/:$PATH

export LSF_DRMAA_CONF=/software/hgi/pkglocal/lsf-drmaa-1.1.1-lsf-9.1/etc/lsf_drmaa.conf

export SV_DIR=/nfs/team151/software/svtoolkit  #######path to sv toolkit eg /software/page/svtoolkit
SV_CLASSPATH="${SV_DIR}/lib/SVToolkit.jar:${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar:${SV_DIR}/lib/gatk/Queue.jar"

echo $(date +"[%b %d %H:%M:%S] Extracting Genome STRiP reference bundle")
# referenceFile=/lustre/scratch115/projects/interval_wgs/analysis/sv/genomes/hs38DH.fa ######path to reference file, copy from "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta"
referenceFile=/lustre/scratch115/realdata/mdt1/projects/interval_wgs/analysis/gatk/Homo_sapiens_assembly38/Homo_sapiens_assembly38.fasta ###path to reference file copy from "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta"
echo "Reference FASTA: "$referenceFile

wDir=/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/discovery/WG_std_two ### path to your working dir
SV_TMPDIR=${wDir}/tmp
mkdir -p ${SV_TMPDIR}
runDir=${wDir}/del_output
mkdir -p ${runDir}
mkdir -p ${runDir}/logs || exit 1

metaData=/lustre/scratch115/projects/interval_wgs/analysis/sv/genomestrip/preprocess_std_two_WG/metadata/ #### path to your metadata dir 
echo "metadata dir: "$metaData

filePrefix=gs_dels

echo "Running Deletion discovery pipeline..."


# Run discovery
java -cp ${SV_CLASSPATH} -Xmx20g -memLimit 6 \
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
    -jobNative "-q normal" \
    -jobNative "-R \"select[mem>20000] rusage[mem=20000]\"" \
    -jobNative "-M 20000" \
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
