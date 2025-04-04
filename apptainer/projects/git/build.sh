#!/bin/bash

set -e

cd git

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

make configure
./configure --prefix=/out/ --cache-file=/cache/config.cache
make all
make install