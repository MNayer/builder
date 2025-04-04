#!/bin/bash

set -e

cd openjpeg

if [ -z "${COMMIT_ID}" ]; then
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive
fi

cmake . -DCMAKE_INSTALL_PREFIX=/out -DCMAKE_BUILD_TYPE=Release
make -j${NPROCS} QUIET=''
make install