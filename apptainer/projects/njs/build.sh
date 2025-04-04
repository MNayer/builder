#!/bin/bash

set -e

cd njs

if [ -z "${COMMIT_ID}" ]; then
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive
fi

./configure 
make -j${NPROCS} QUIET=''

mv build/libnjs.a /out/
mv build/njs /out/