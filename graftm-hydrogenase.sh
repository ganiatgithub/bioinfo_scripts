#!/bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --partition=kaleen
#SBATCH --mail-type=ALL

JOB_BASE=/home/Staff/uqgni1/98_hydrogen
JOB_DIR=${JOB_BASE}/${GENE}/${NAME}
GRAFTM_HYDROGENASE_DIR=/home/Staff/uqgni1/tools/graftM-packages/hydrogen

mkdir -p ${JOB_DIR}
cd ${JOB_DIR}
echo "Starting graftm for gene ${GENE} and input ${NAME} at `date`"
singularity exec /home/Staff/uqgni1/containers/graftm_v0.13.1.sif bash -c "graftM graft \
--forward ${GENOME} \
--input_sequence_type nucleotide \
--graftm_package ${GRAFTM_HYDROGENASE_DIR}/${GENE} \
--search_method hmmsearch \
--threads 4 \
--output_directory ${JOB_DIR}/out \
--force"
echo "Finished graftm for gene ${GENE} and input ${NAME} at `date`"
