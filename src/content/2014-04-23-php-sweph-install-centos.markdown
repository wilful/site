Title: "Сборка и установка модуля php-sweph"
Date: 2014-04-23 13:25:55 +0600
Category: linux
Authors: A. Semenov
Tags: centos, linux, php, build

Просто абзац

UPD(16.01.17)...

<!--more-->

yum install php-devel php subversion wget tar gcc file make git -y
BUILD=/usr/src
SWEURL=ftp://ftp.astro.com/pub/swisseph/swe_unix_src_2.06.tar.gz
INCLUDEDIR=/usr/local/include
LIBDIR=/usr/local/lib
PHPMODDIR=/usr/lib64/php/modules
pushd $BUILD
wget $SWEURL
mkdir -p $BUILD/swe
tar xf $(basename $SWEURL) -C $BUILD/swe
pushd swe/src
make
popd
ln -s $BUILD/swe/src/libswe.a $LIBDIR
ln -s $BUILD/swe/src/sweodef.h $INCLUDEDIR
ln -s $BUILD/swe/src/swephexp.h $INCLUDEDIR
git clone https://github.com/cyjoelchen/php-sweph
pushd php-sweph
phpize
./configure  --enable-sweph
make
rm $LIBDIR/libswe.a $INCLUDEDIR/{sweodef.h,swephexp.h}
ln -sf $BUILD/php-sweph/modules/sweph.so $PHPMODDIR
cat >/etc/php.d/sweph.ini <<EOF
extension=sweph.so
EOF
php -m | grep sweph

