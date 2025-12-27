#!/bin/bash
D=$(cd $(dirname $0); pwd)
mkdir -p $D/{build,dist,run} &&
cd $D &&

V=17
SV=7
FN=postgresql-$V.$SV
F=$FN.tar.bz2
I=$D/run/pg-$V

$I/stop
rm -rfv $D/run/pg-$V &&
cd $D/build && rm -rfv postgresql-$V.$SV && tar xvf $D/dist/postgresql-$V.$SV.tar.bz2 &&
cd postgresql-$V.$SV &&
meson setup build --prefix=$I -Dpgport=54317 -Ddocs=enabled -Ddocs_html_style=website \
    -Dbonjour=disabled -Dbsd_auth=disabled -Duuid=e2fs -Dgssapi=disabled \
    -Dldap=disabled -Dpam=disabled -Dselinux=disabled -Dsystemd=disabled &&
cd $D/build/$FN/build && ninja docs all && meson test && ninja install-world &&
export PATH=$I/bin:$PATH &&
cd $I && $I/bin/initdb -D $I/data && mkdir $I/log &&
echo "$I/bin/pg_ctl start -D $I/data --log=$I/log/postgresql.log --wait" > $I/start && chmod +x $I/start &&
echo "$I/bin/pg_ctl stop -D $I/data --wait" > $I/stop && chmod +x $I/stop &&
echo "$I/bin/pg_ctl status -D $I/data" > $I/status && chmod +x $I/status &&
echo "$I/bin/pg_ctl reload -D $I/data" > $I/reload && chmod +x $I/reload &&
$I/start && 
cd $D/build/$FN/build && meson test --setup running --suite regress-running &&
$I/bin/createdb $USER &&
rm -rfv $D/build/postgresql-$V.$SV && 
echo "++++++++++ PostgreSQL $V.$SV installed in $I ++++++++++++" &&

cd $D &&
FV=2.5.0 && SLV=3.46.0
cd $D/build && rm -rfv sqlite_fdw-$FV && tar xvf $D/dist/sqlite_fdw-$FV.tar.gz &&
cd sqlite_fdw-$FV &&
make USE_PGXS=1 SQLITE_FOR_TESTING_DIR=$D/run/sl-$SLV &&
make install USE_PGXS=1 SQLITE_FOR_TESTING_DIR=$D/run/sl-$SLV &&
mv sql/17.0 sql/17.$SV && mv expected/17.0 expected/17.$SV &&
rm -rfv /tmp/sqlite_fdw_test
mkdir -p /tmp/sqlite_fdw_test &&
cp -a sql/init_data/*.data /tmp/sqlite_fdw_test &&
$D/run/sl-$SLV/bin/sqlite3 /tmp/sqlite_fdw_test/post.db < sql/init_data/init_post.sql &&
$D/run/sl-$SLV/bin/sqlite3 /tmp/sqlite_fdw_test/core.db < sql/init_data/init_core.sql &&
$D/run/sl-$SLV/bin/sqlite3 /tmp/sqlite_fdw_test/common.db < sql/init_data/init.sql &&
$D/run/sl-$SLV/bin/sqlite3 /tmp/sqlite_fdw_test/selectfunc.db < sql/init_data/init_selectfunc.sql &&
make installcheck USE_PGXS=1 SQLITE_FOR_TESTING_DIR=$D/run/sl-$SLV &&
echo "+++++++++ sqlite_fdw installed ++++++++++"
