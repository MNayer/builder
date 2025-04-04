#!/bin/bash

set -e

cd ghostpdl

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

./autogen.sh
./configure --prefix=/out/ --cache-file=/cache/config.cache
make
make install