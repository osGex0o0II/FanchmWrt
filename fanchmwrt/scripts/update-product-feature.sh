#!/bin/sh
set -eu

usage() {
	printf '%s\n' 'Usage: update-product-feature.sh --feature-file FILE --board BOARD --arch ARCH --rootfs-size SIZE' >&2
	exit 2
}

feature_file=
board=
arch=
rootfs_size=

while [ "$#" -gt 0 ]; do
	case "$1" in
		--feature-file)
			[ "$#" -ge 2 ] || usage
			feature_file=$2
			shift 2
			;;
		--board)
			[ "$#" -ge 2 ] || usage
			board=$2
			shift 2
			;;
		--arch)
			[ "$#" -ge 2 ] || usage
			arch=$2
			shift 2
			;;
		--rootfs-size)
			[ "$#" -ge 2 ] || usage
			rootfs_size=$2
			shift 2
			;;
		*)
			usage
			;;
	esac
done

[ -n "$feature_file" ] && [ -n "$board" ] && [ -n "$arch" ] || usage

[ -f "$feature_file" ] && sed -i '/^EXPAND_ROOT=/d' "$feature_file"

case "$board:$arch" in
	x86:*|*:x86_64|*:i386|rockchip*:*)
		mkdir -p "$(dirname "$feature_file")"
		case "$rootfs_size" in
			''|*[!0-9]*) rootfs_size=0 ;;
		esac
		if [ "$rootfs_size" -gt 300 ]; then
			expand_root=1
		else
			expand_root=0
		fi
		printf 'EXPAND_ROOT=%s\n' "$expand_root" >> "$feature_file"
		;;
	*)
		if [ -f "$feature_file" ] && [ ! -s "$feature_file" ]; then
			rm -f "$feature_file"
		fi
		;;
esac
