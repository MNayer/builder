#!/bin/bash

set -e

cd mruby

if [ -z "${COMMIT_HASH}" ]; then
    git checkout ${COMMIT_HASH}
    git submodule update --init --recursive
fi

rake
PREFIX=/out rake install