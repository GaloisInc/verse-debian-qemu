#!/bin/sh

set -e

RAW_IMG="${AUTOPKGTEST_TMP}/q.img"

echo -n "Testing if qemu-img creates images..."
qemu-img create "${RAW_IMG}" 12G
echo "done."

echo -n "Testing for correct image size..."
ls -l "${RAW_IMG}" | grep -qs " 12884901888 "
echo "done."
echo -n "Testing if file is sparse..."
ls -s "${RAW_IMG}" | grep -qs "^0 "
echo "done."

QCOW2_IMG="${AUTOPKGTEST_TMP}/q.qcow2"
echo "Testing if conversion to a qcow2 image works..."
qemu-img convert -Oqcow2 "${RAW_IMG}" "${QCOW2_IMG}"
echo "done."

echo "Testing if image is qcow2 works..."
file "${QCOW2_IMG}" | grep "QEMU QCOW Image .* 12884901888"
echo "done."

