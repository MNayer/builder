#!/bin/bash

set -e

cd libxml2

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

./autogen.sh
./configure --prefix=/out/ --cache-file=/cache/config.cache
make -j${NPROCS} QUIET=''
make install
