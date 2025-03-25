#!/bin/bash

source ./config.sh
#export APPTAINER_TEMPDIR ${APPTAINER_TEMPDIR}

# Build base image
apptainer build -F apptainer/base.sif apptainer/base/base_plugin.def

# Build project images
apptainer build -F apptainer/projects/binutils-gdb/container.sif apptainer/projects/binutils-gdb/container.def
#apptainer build -F apptainer/projects/file/container.sif apptainer/projects/file/container.def
