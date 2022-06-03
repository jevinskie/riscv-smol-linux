#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

set -o xtrace

rm -f smol-initramfs.cpio.gz
rm -rf smol-initramfs
cp -R ${INITRAMFS_PREFIX} smol-initramfs
mkdir -p smol-initramfs

pushd smol-initramfs

fakeroot -- /usr/bin/env zsh << EOS
set -o errexit
set -o nounset
set -o pipefail

set -o xtrace

mkdir -p dev
mkdir -p proc
mkdir -p sys
ln -s sbin/init init
pushd dev
mknod console c 5 1
mknod ram b 1 0
mknod tty0 c 4 0
mknod tty1 c 4 1
mknod tty2 c 4 2
mknod tty3 c 4 3
mknod tty4 c 4 4
popd # dev
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../smol-initramfs.cpio.gz
EOS

popd # smol-initramfs
