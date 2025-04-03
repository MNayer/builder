#!/bin/bash

set -e

cd squashfs-tools/squashfs-tools

if [ -z "${COMMIT_ID}" ]; then
    git checkout ${COMMIT_ID}
    git submodule update --init --recursive
fi

# TODO: cc -c -O2  -I. -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_GNU_SOURCE -DCOMP_DEFAULT=\"gzip\" -Wall -DGZIP_SUPPORT -DLZO_SUPPORT -DLZ4_SUPPORT -DXZ_SUPPORT -DZSTD_SUPPORT -DXATTR_SUPPORT -DXATTR_DEFAULT -DXATTR_OS_SUPPORT -DREPRODUCIBLE_DEFAULT -DMAX_READER_THREADS=1024 -DSMALL_READER_THREADS=8 -DBLOCK_READER_THREADS=3 -DVERSION=\"4.6.1-d78350ca\" -DDATE=\"2025/04/01\" -DYEAR=\"2025\"  -DCOMPRESSORS="\"gzip (default)\nlzo\nlz4\nxz\nzstd\"" mksquashfs_help.c
# The quotes in the final argument are a problem. If we set the flags ourselves they should go away?

sed -i 's|INSTALL_PREFIX = /usr/local|INSTALL_PREFIX = /out|' Makefile
make