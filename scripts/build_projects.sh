#!/bin/bash

set -e

source ./scripts/config.sh

#project_path=./apptainer/projects/binutils-gdb
project_path=./apptainer/projects/file

# Create output directory
mkdir -p ${OUT_DIR}

# Create overlay to make container writable
mkdir -p ${WORK_DIR}
tempdir=$(mktemp -d -p ${WORK_DIR})
mkdir ${tempdir}/tmp
apptainer overlay create --sparse --size ${OVERLAY_SIZE} ${tempdir}/overlay.img

# Build project
apptainer run \
  --contain \
  --overlay ${tempdir}/overlay.img \
  --bind ${OUT_DIR}:/out \
  --bind ${project_path}/build.sh:/work/build.sh:ro \
  --bind ${tempdir}/tmp:/tmp/ \
  --pwd /work/ \
  --env "NPROCS=${NPROCS}" \
  --env "ADDFLAGS=${ADD_FLAGS}" \
  ${project_path}/container.sif \
  compile

# Remove build artifacts
rm -rf ${tempdir}
