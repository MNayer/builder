#!/bin/bash

set -e

cd mariadb

if [ -z "${COMMIT_ID}" ]; then
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive
fi

cmake . -DCMAKE_INSTALL_PREFIX=/out -DBUILD_CONFIG=mysql_release
make -j${NPROCS} QUIET=''
make install