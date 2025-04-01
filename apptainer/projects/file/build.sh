#!/bin/bash

set -e

cd file

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

autoreconf -fi
./configure --prefix=/out/ --cache-file=/cache/config.cache
make -j${NPROCS} QUIET=''
make install
