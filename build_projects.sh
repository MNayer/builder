#!/bin/bash

set -e

temproot=/tmp/laica/
project_path=./apptainer/projects/file
output_path=./out
nprocs=10
overlay_size=8192

# Create overlay to make container writable
mkdir -p ${temproot}
tempdir=$(mktemp -d -p ${temproot})
mkdir ${tempdir}/tmp
apptainer overlay create --sparse --size ${overlay_size} ${tempdir}/overlay.img

# Build project
apptainer run \
  --contain \
  --overlay ${tempdir}/overlay.img \
  --bind ${output_path}:/out \
  --bind ${project_path}/build.sh:/work/build.sh:ro \
  --bind ${tempdir}/tmp:/tmp/ \
  --pwd /work/ \
  --env "NPROCS=${nprocs}" \
  ${project_path}/container.sif \
  compile

# Remove build artifacts
rm -rf ${tempdir}
