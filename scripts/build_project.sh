#!/bin/bash
#SBATCH --job-name=laica-projects
#SBATCH --partition=cpu-2h
#SBATCH --gpus-per-node=0
#SBATCH --ntasks-per-node=32
#SBATCH --output=logs/job-projects-%j.out

set -e

# Check if exactly three parameters are provided
if [ $# -eq 3 ]; then
    project_name=$1
    dataset=$2
    commit_hash=$3
fi

if [ $# -eq 0 ]; then
    # Ensure SLURM_ARRAY_TASK_ID variable is set
    if [ -z "$SLURM_ARRAY_TASK_ID" ]; then
        echo "Error: No parameters provided and SLURM_ARRAY_TASK_ID variable is not set."
        exit 1
    fi
    
    # Ensure SLURM_ARRAY_TASK_ID is a valid integer
    if ! [[ "$SLURM_ARRAY_TASK_ID" =~ ^[0-9]+$ ]]; then
        echo "Error: SLURM_ARRAY_TASK_ID variable must be an integer."
        exit 1
    fi
    
    # Check if file exists
    FILE="slurm/targets.txt"
    if [ ! -f "$FILE" ]; then
        echo "Error: File $FILE not found."
        exit 1
    fi
    
    # Read the specified line
    LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$FILE")
    
    # Check if line exists
    if [ -z "$LINE" ]; then
        echo "Error: Line number $SLURM_ARRAY_TASK_ID is out of range."
        exit 1
    fi
    
    # Extract values from the line
    read -r project_name dataset commit_hash <<< "$LINE"
fi

# Output the values
echo "COMPILING: "
echo "Time: $(date)"
echo "Project name: ${project_name}"
echo "Dataset: ${dataset}"
echo "Commit hash: ${commit_hash}"

if [ ! -z "$SLURM_ARRAY_JOB_ID" ]; then
    echo "SLURM_JOB_ID: ${SLURM_JOB_ID}"
    echo "SLURM_ARRAY_JOB_ID: ${SLURM_ARRAY_JOB_ID}"
    echo "SLURM_NODEID: ${SLURM_NODEID}"
    echo "SLURMD_NODENAME: ${SLURMD_NODENAME}"
    echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"
fi

source ./scripts/config.sh

project_path=./apptainer/projects/${project_name}
outdir=${OUT_DIR_PREFIX}/${project_name}/${dataset}/${commit_hash}
cachedir=${CACHE_DIR_PREFIX}/${project_name}

if [ -f ${outdir}/done ]; then
    echo "done file found. exit early"
    exit 0
fi

# Create output directory
mkdir -p ${outdir}
mkdir -p ${cachedir}

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
  --bind ${cachedir}:/cache \
  --bind ${project_path}/build.sh:/work/build.sh:ro \
  --bind ${tempdir}/tmp:/tmp/ \
  --pwd /work/ \
  --env "NPROCS=${NPROCS}" \
  --env "ADDFLAGS=${ADD_FLAGS}" \
  --env "COMMIT_HASH=\"${commit_hash}\"" \
  ${project_path}/container.sif \
  compile

echo ${SECONDS} > ${outdir}/done