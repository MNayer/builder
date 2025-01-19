#!/bin/bash

# Build base image
apptainer build apptainer/base.sif apptainer/base.def

# Build project images
#apptainer build apptainer/projects/binutils-gdb/container.sif apptainer/projects/binutils-gdb/container.def
apptainer build apptainer/projects/file/container.sif apptainer/projects/file/container.def
