#!/bin/bash
D=$(cd $(dirname $0); pwd)
mkdir -p $D/{build,dist,run} &&
cd $D &&

V=3.46.0
rm -rfv $D/run/sl-$V &&
cd $D/build && rm -rfv sqlite-$V && tar xvf $D/dist/sqlite-$V.tar.bz2 &&
cd sqlite-$V && ./configure --prefix=$D/run/sl-$V --disable-tcl --enable-fts5 &&
make sqlite3 && make install &&
rm -rf $D/build/sqlite-$V &&

echo "============================="