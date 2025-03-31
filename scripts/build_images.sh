#!/bin/bash

source ./scripts/config.sh

mkdir -p ${APPTAINER_TEMPDIR}

# Build base image
apptainer build -F apptainer/base.sif apptainer/base/base_shims.def

# Build project images
#apptainer build -F apptainer/projects/binutils-gdb/container.sif apptainer/projects/binutils-gdb/container.def
apptainer build -F apptainer/projects/file/container.sif apptainer/projects/file/container.def
