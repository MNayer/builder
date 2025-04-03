#!/bin/bash

set -e

# Check if exactly three parameters are provided
if [ $# -eq 3 ]; then
    project_name=$1
    dataset=$2
    commit_hash=$3
fi

if [ $# -eq 0 ]; then
    # Ensure SLURM_ARRAY_JOB_ID variable is set
    if [ -z "$SLURM_ARRAY_JOB_ID" ]; then
        echo "Error: No parameters provided and SLURM_ARRAY_JOB_ID variable is not set."
        exit 1
    fi
    
    # Ensure SLURM_ARRAY_JOB_ID is a valid integer
    if ! [[ "$SLURM_ARRAY_JOB_ID" =~ ^[0-9]+$ ]]; then
        echo "Error: SLURM_ARRAY_JOB_ID variable must be an integer."
        exit 1
    fi
    
    # Check if file exists
    FILE="slurm/targets.txt"
    if [ ! -f "$FILE" ]; then
        echo "Error: File $FILE not found."
        exit 1
    fi
    
    # Read the specified line
    LINE=$(sed -n "${SLURM_ARRAY_JOB_ID}p" "$FILE")
    
    # Check if line exists
    if [ -z "$LINE" ]; then
        echo "Error: Line number $SLURM_ARRAY_JOB_ID is out of range."
        exit 1
    fi
    
    # Extract values from the line
    read -r project_name dataset commit_hash <<< "$LINE"
fi

# Output the values
echo "COMPILING: "
echo "Project name: ${project_name}"
echo "Dataset: ${dataset}"
echo "Commit hash: ${commit_hash}"

source ./scripts/config.sh

project_path=./apptainer/projects/${project_name}
outdir=${OUT_DIR_PREFIX}/${project_name}/${dataset}/${commit_hash}

# Create output directory
mkdir -p ${outdir}

# Create overlay to make container writable
mkdir -p ${WORK_DIR}

tempdir=$(mktemp -d -p ${WORK_DIR})
mkdir ${tempdir}/tmp

trap 'rm -rf ${tempdir}' EXIT

apptainer overlay create --sparse --size ${OVERLAY_SIZE} ${tempdir}/overlay.img

# Build project
apptainer run \
  --contain \
  --overlay ${tempdir}/overlay.img \
  --bind ${outdir}:/out \
  --bind ${project_path}/build.sh:/work/build.sh:ro \
  --bind ${tempdir}/tmp:/tmp/ \
  --pwd /work/ \
  --env "NPROCS=${NPROCS}" \
  --env "ADDFLAGS=${ADD_FLAGS}" \
  --env "COMMIT_HASH=\"${commit_hash}\"" \
  ${project_path}/container.sif \
  compile

touch ${outdir}/done