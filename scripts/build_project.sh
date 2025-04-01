#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Please provide a project name"
fi


source ./scripts/config.sh

project_name=$1
project_path=./apptainer/projects/${project_name}

outdir=${OUT_DIR_PREFIX}/${project_name}

echo "Compiling ${project_name}"

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
  ${project_path}/container.sif \
  compile

touch ${outdir}/done