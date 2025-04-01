#!/bin/bash

set -e

cd FFmpeg

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

./configure --prefix=/out/
make -j${NPROCS} QUIET=''
make install