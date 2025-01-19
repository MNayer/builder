#!/bin/bash

set -e

cd binutils-gdb
git checkout 26dd9cb647140db87a5a530fd9f044d356e081de

./configure
make -j${NPROCS} QUIET=''

cp ./bfd/doc/chew /out/
cp ./gprofng/src/gprofng-display-src /out/
cp ./gprofng/src/gprofng-display-text /out/
cp ./gprofng/src/gprofng-collect-app /out/
cp ./gprofng/src/gprofng /out/
cp ./gprofng/src/gprofng-archive /out/
cp ./gas/as-new /out/
cp ./binutils/bfdtest2 /out/
cp ./binutils/addr2line /out/
cp ./binutils/strings /out/
cp ./binutils/cxxfilt /out/
cp ./binutils/nm-new /out/
cp ./binutils/testsuite/gentestdlls /out/
cp ./binutils/objdump /out/
cp ./binutils/objcopy /out/
cp ./binutils/elfedit /out/
cp ./binutils/bfdtest1 /out/
cp ./binutils/sysinfo /out/
cp ./binutils/size /out/
cp ./binutils/readelf /out/
cp ./binutils/ar /out/
cp ./binutils/ranlib /out/
cp ./binutils/strip-new /out/
cp ./gprof/gprof /out/
cp ./gdb/gdb /out/
cp ./ld/ld-new /out/
cp ./gdbserver/gdbreplay /out/
cp ./gdbserver/gdbserver /out/
