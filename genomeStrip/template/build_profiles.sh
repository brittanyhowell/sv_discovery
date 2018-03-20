#!/bin/bash

archiveList=$1
binSize=$2

export PATH=/software/hgi/pkglocal/samtools-1.3.1/bin:$PATH
export PATH=/software/R-3.0.0/bin:$PATH
export PATH=/software/java/bin/:$PATH

export LSF_DRMAA_CONF=/software/hgi/pkglocal/lsf-drmaa-1.1.1-lsf-9.1/etc/lsf_drmaa.conf

export SV_DIR=       #######add path to SV toolkit here eg "/software/page/svtoolkit"
SV_CLASSPATH="${SV_DIR}/lib/SVToolkit.jar:${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar:${SV_DIR}/lib/gatk/Queue.jar"

echo $(date +"[%b %d %H:%M:%S] Extracting Genome STRiP reference bundle")
referenceFile=     ######### path to reference file - dopy this from me "/software/page/svtoolkit/1000G_phase3/human_g1k_hs37d5.fasta" 
echo "Reference FASTA: "$referenceFile

wDir=  #######path to your working dir
SV_TMPDIR=${wDir}/tmp
mkdir -p ${SV_TMPDIR}
mdDir=${wDir}/metadata
profilesDir=${wDir}/profiles_${binSize}
mkdir -p ${mdDir}
mkdir -p ${profilesDir}/logs

echo $(date +"[%b %d %H:%M:%S] Unarchiving metadata")

java -cp ${SV_CLASSPATH} -Xmx4g \
    org.broadinstitute.gatk.queue.QCommandLine \
    -S ${SV_DIR}/scripts/firecloud/UnarchiveData.q \
    -S ${SV_DIR}/qscript/SVQScript.q \
    -gatk ${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar \
    -cp ${SV_CLASSPATH} \
    -R ${referenceFile} \
    -archive ${archiveList} \
    -deleteArchives true \
    -O ${mdDir} \
    -tempDir ${SV_TMPDIR} \
    -jobLogDir ${SV_TMPDIR} \
    -jobRunner Drmaa \
    -gatkJobRunner Drmaa \
    -jobNative "-q long" \
    -jobNative "-R \"select[mem>10000] rusage[mem=10000]\"" \
    -jobNative "-M 10000" \
    -run \
    || exit 1

echo $(date +"[%b %d %H:%M:%S] Building profiles")

mdDirArg=$(find ${mdDir} -mindepth 1 -maxdepth 1 | awk '{print "-md " $0}' | xargs)
echo "MD_DIR=${mdDirArg}"
find ${mdDir} -mindepth 1 -maxdepth 1 | awk '{print $0 "/headers.bam"}' > bam_files.list
cat bam_files.list

# Store the merged genderMapFile within the profiles directory, as this gender map is required to run the LCNV pipeline
genderMapFile=${profilesDir}/sample_gender.report.txt
find ${mdDir} -name sample_gender.report.txt | head -1 | xargs head -1 > ${genderMapFile}
find ${mdDir} -name sample_gender.report.txt -exec tail -n +2 {} \; >> ${genderMapFile}

java -cp ${SV_CLASSPATH} -Xmx4g \
    org.broadinstitute.gatk.queue.QCommandLine \
    -S ${SV_DIR}/qscript/profiles/GenerateDepthProfiles.q \
    -S ${SV_DIR}/qscript/SVQScript.q \
    -gatk ${SV_DIR}/lib/gatk/GenomeAnalysisTK.jar \
    -cp ${SV_CLASSPATH} \
    -configFile ${SV_DIR}/conf/genstrip_parameters.txt \
    -tempDir ${SV_TMPDIR} \
    -jobLogDir ${profilesDir}/logs \
    -R ${referenceFile} \
    ${mdDirArg} \
    -I bam_files.list \
    -profileBinSize ${binSize} \
    -runDirectory ${profilesDir} \
    -jobRunner Drmaa \
    -gatkJobRunner Drmaa \
    -jobNative "-q long" \
    -jobNative "-R \"select[mem>10000] rusage[mem=10000]\"" \
    -jobNative "-M 10000" \
    -run \
    || exit 1

echo $(date +"[%b %d %H:%M:%S] Archiving profiles directory")
tar -cvzf ${wDir}/profiles_${binSize}.tar.gz ${profilesDir} || exit 1

echo $(date +"[%b %d %H:%M:%S] Building profiles completed successfully")

