#!/bin/sh

set -e

arch=$(dpkg --print-architecture)
echo "debian architecture: $arch"
case $arch in
  ( amd64 | x86_64 ) arch=x86_64 ;;
  ( i[3456]86 ) arch=i386 ;;
  ( arm64 | aarch64 ) arch=aarch64 ;;
  ( arm | armhf ) arch=arm ;;
  ( ppc64el | powerpc64le ) arch=ppc64el ;;
  ( s390x ) ;;
  ( * ) echo "Warning: unmapped architecture $arch" ;;
esac
echo "qemu   architecture: $arch"

tested=
for f in qemu-$arch qemu-$arch-static ; do
  [ -x /usr/bin/$f ] || continue
  echo "Checking if $f can run executables:"
  echo "glob with sh: $f /bin/sh -c '$f /bin/ls -ld debian/':"
  ls="$($f /bin/sh -c "$f /bin/ls -ld debian/*")"
  echo "$ls"
  case "$ls" in
    (*debian/control*) ;;
    *) echo "Expected output not found" >&2; exit 1;;
  esac
  echo ok.
  tested=y
done
if [ ! "$tested" ]; then
  echo "Warning: qemu-$arch[-static] not found, not testing qemu-user"
fi
