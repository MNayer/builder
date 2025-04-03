#!/bin/bash

set -e

cd pjproject

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

./configure CFLAGS="-fPIC" --prefix=/out/ --cache-file=/cache/config.cache
make -j${NPROCS} QUIET=''
make install
