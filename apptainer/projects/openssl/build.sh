#!/bin/bash

set -e

cd openssl

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

./Configure --prefix=/out/
make -j${NPROCS} QUIET=''
make install
