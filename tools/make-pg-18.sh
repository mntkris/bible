#!/bin/bash
D=$(cd $(dirname $0); pwd)
mkdir -p $D/{build,dist,run} &&
cd $D &&

V=18
SV=1
FN=postgresql-$V.$SV
F=$FN.tar.bz2
I=$D/run/pg-$V

$I/stop
rm -rfv $D/run/pg-$V &&
cd $D/build && rm -rfv postgresql-$V.$SV && tar xvf $D/dist/postgresql-$V.$SV.tar.bz2 &&
cd postgresql-$V.$SV &&
meson setup build --prefix=$I -Dpgport=54318 -Ddocs=enabled -Ddocs_html_style=website \
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
echo "++++++++++ PostgreSQL $V.$SV installed in $I ++++++++++++"
