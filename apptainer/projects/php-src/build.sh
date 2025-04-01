#!/bin/bash

set -e

cd php-src

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

./buildconf
./configure --prefix=/out/ --cache-file=/cache/config.cache
make -j${NPROCS} QUIET=''
make install
