#!/bin/bash

set -e

cd file
git checkout 1778642b8ba3d947a779a36fcd81f8e807220a19

autoreconf -fi
./configure
make -j${NPROCS} QUIET=''

cp ./src/.libs/file /out/
