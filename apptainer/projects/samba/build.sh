#!/bin/bash

set -e

cd samba

if [ -z "${COMMIT_ID}" ]; then
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive
fi

./configure --prefix=/out/ --with-cachedir=/cache/
make -j${NPROCS} QUIET=''
make install