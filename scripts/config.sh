#!/bin/bash

WORK_DIR=$(pwd)/work/

# Build projects settings
OUT_DIR_PREFIX=out
CACHE_DIR_PREFIX=.cache
NPROCS=10
OVERLAY_SIZE=8192
ADD_FLAGS="-gfull -g3 -gdwarf-4"
