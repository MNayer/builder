#!/bin/bash

set -e

cd binutils-gdb
git checkout 26dd9cb647140db87a5a530fd9f044d356e081de

./configure --prefix=/out/
make
make install