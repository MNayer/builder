#!/bin/bash

set -e

cd qemu

if [ -z "${COMMIT_ID}" ]; then
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive
fi

./configure --prefix=/out/ --disable-werror
make -j${NPROCS} QUIET=''
make install