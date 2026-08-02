#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)

expect_build_sequence() {
	file=$1
	defconfig=$(grep -nF 'make defconfig' "$root/$file" | head -n 1 | cut -d: -f1)
	linux_compile=$(grep -nF 'make target/linux/compile V=s' "$root/$file" | head -n 1 | cut -d: -f1)
	fwx_compile=$(grep -nF 'make package/fanchmwrt/fwx/compile V=s' "$root/$file" | head -n 1 | cut -d: -f1)
	fwxd_compile=$(grep -nF 'make package/fanchmwrt/fwxd/compile V=s' "$root/$file" | head -n 1 | cut -d: -f1)

	[ -n "$defconfig" ]
	[ -n "$linux_compile" ]
	[ -n "$fwx_compile" ]
	[ -n "$fwxd_compile" ]
	[ "$defconfig" -lt "$linux_compile" ]
	[ "$linux_compile" -lt "$fwx_compile" ]
	[ "$linux_compile" -lt "$fwxd_compile" ]
}

expect_build_sequence docs/build/quick-start.md
expect_build_sequence fanchmwrt/README.md

echo 'PASS: build docs include the kernel prerequisite sequence'
