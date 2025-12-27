#!/bin/bash
D=$(cd $(dirname $0); pwd)
mkdir -p $D/{build,dist,run} &&
D=$D/dist &&
cd $D &&

shopt -s dotglob &&

mkdir -p $D/.sqlite &&
cd $D/.sqlite &&
fossil open https://sqlite.org/src &&
fossil pull &&
fossil tag list | grep version-3 &&

V=3.46.0 &&
DIR=$D/sqlite-$V &&
FILE=$DIR.tar.bz2 &&
if [ ! -f $FILE ]; then
    rm -f $FILE &&
    cd $D/.sqlite && fossil update version-$V && cd $D &&
    cp -Rav $D/.sqlite $DIR && tar cvf $FILE sqlite-$V/* &&
    rm -rfv $DIR
fi &&

V=3.49.0 &&
DIR=$D/sqlite-$V &&
FILE=$DIR.tar.bz2 &&
if [ ! -f $FILE ]; then
    rm -f $FILE &&
    cd $D/.sqlite && fossil update version-$V && cd $D &&
    cp -Rav $D/.sqlite $DIR && tar cvf $FILE sqlite-$V/* &&
    rm -rfv $DIR
fi &&

V=3.51.1 &&
DIR=$D/sqlite-$V &&
FILE=$DIR.tar.bz2 &&
if [ ! -f $FILE ]; then
    rm -f $FILE &&
    cd $D/.sqlite && fossil update version-$V && cd $D &&
    cp -Rav $D/.sqlite $DIR && tar cvf $FILE sqlite-$V/* &&
    rm -rfv $DIR
fi &&


cd $D &&

V=17.7 &&
FILE=postgresql-$V.tar.bz2 &&
if [ ! -f $FILE ]; then
    wget https://ftp.postgresql.org/pub/source/v$V/$FILE
fi &&

V=18.1 &&
FILE=postgresql-$V.tar.bz2 &&
if [ ! -f $FILE ]; then
    wget https://ftp.postgresql.org/pub/source/v$V/$FILE
fi &&


V=2.5.0 &&
FILE=$D/sqlite_fdw-$V.tar.gz
if [ ! -f $FILE ]; then
    wget https://github.com/pgspider/sqlite_fdw/archive/refs/tags/v$V.tar.gz -O $FILE
fi &&

echo "============================="