#!/bin/bash

set -e

BUILD_DIR=jasper-build

cd jasper

if [ -z "${COMMIT_ID}" ]; then
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive
fi

cd ..


mkdir -p ${BUILD_DIR}
cmake -Hjasper -B${BUILD_DIR} -DCMAKE_INSTALL_PREFIX=/out -DCMAKE_BUILD_TYPE=Release
cmake --build ${BUILD_DIR}
cmake --build ${BUILD_DIR} --target install