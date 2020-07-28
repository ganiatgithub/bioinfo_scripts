#!/bin/bash
#SBATCH --job-name sra_download
#SBATCH --time 1-00:00:00
#SBATCH --nodes 1
#SBATCH --cpus-per-task 1
#SBATCH --output=/home.roaming/uqtcudd1/jobs/s%j_job.out
#SBATCH --error=/home.roaming/uqtcudd1/jobs/s%j_job.error

true # next lines are not functional
# ^ done this to effectively comment out the email sbatch lines below

#SBATCH --mail-type="TIME_LIMIT_50,TIME_LIMIT_80,TIME_LIMIT_90,TIME_LIMIT,ALL"
#SBATCH --mail-user=t.cuddihy1@uq.edu.au # change

# run as bulk using:
#while read line
#  do export SAMPLE=$line
#  sbatch sra_download.sh --export=ALL --nice=1000 # export all of the env var #
#done < rhys_sra_accs_180827.txt
# e.g.

# load conda environment
source activate beatson_py2

TEMP_DIRECTORY=/QNAP/thom/rhys/sra_180905
JOB_TMP_DIR=${TEMP_DIRECTORY}/reads
MASTER_LOG=${TEMP_DIRECTORY}/master.log

mkdir -p ${TEMP_DIRECTORY}
mkdir -p ${JOB_TMP_DIR}

sra_paired() {
  local SRA="${1}"
  local x=$(
    fastq-dump -I -X 1 -Z --split-spot "${SRA}" 2>/dev/null \
      | awk '{if(NR % 2 == 1) print substr($1,length($1),1)}' \
      | uniq \
      | wc -l
  )
  [[ ${x} == 2 ]]
}

download_single_run() {
    local ACC=${1}
    echo "Starting download of ${ACC} (paired)" >> ${TEMP_DIRECTORY}/${ACC}.step.log
    if fastq-dump --outdir ${JOB_TMP_DIR} ${ACC} &>> ${TEMP_DIRECTORY}/${ACC}.step.log; then
        echo "${ACC} downloaded successfully" >> ${MASTER_LOG}
    else
        echo "${ACC} failed to download" >> ${MASTER_LOG}
    fi
}

download_paired_run() {
    local ACC=${1}
    echo "Starting download ${ACC} (single)" >> ${TEMP_DIRECTORY}/${ACC}.step.log
    if fastq-dump -I --split-files --outdir ${JOB_TMP_DIR} ${ACC} &>> ${TEMP_DIRECTORY}/${ACC}.step.log; then
        echo "${ACC} downloaded successfully" >> ${MASTER_LOG}
    else
        echo "${ACC} failed to download" >> ${MASTER_LOG}
    fi
}

if sra_paired "${SAMPLE}"; then
#if true; then
    echo "${SAMPLE} contains paired-end sequencing data. Downloading..." >> ${MASTER_LOG}
    download_paired_run "${SAMPLE}"
else
    echo "${SAMPLE} does not contain paired-end sequencing data. Downloading..." >> ${MASTER_LOG}
    download_single_run "${SAMPLE}"
fi

rm ${JOB_TMP_DIR}/${ACC}*
