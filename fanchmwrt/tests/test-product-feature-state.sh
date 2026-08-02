#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
script="$root/fanchmwrt/scripts/update-product-feature.sh"
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT HUP INT TERM

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

[ -f "$script" ] || fail 'product feature state helper is missing'
grep -F -- 'update-product-feature.sh' "$root/Makefile" >/dev/null || \
	fail 'fwx_init does not invoke the product feature state helper'

feature_file="$temp_dir/product_feature"

sh "$script" \
	--feature-file "$feature_file" \
	--board x86 \
	--arch x86_64 \
	--rootfs-size 512

grep -Fqx 'EXPAND_ROOT=1' "$feature_file" || fail 'x86 feature state was not written'

printf 'OTHER_FEATURE=1\nEXPAND_ROOT=1\n' > "$feature_file"

sh "$script" \
	--feature-file "$feature_file" \
	--board mediatek \
	--arch aarch64_cortex-a53 \
	--rootfs-size 512

grep -Fqx 'OTHER_FEATURE=1' "$feature_file" || fail 'unrelated feature state was removed'
if grep -Fqx 'EXPAND_ROOT=1' "$feature_file"; then
	fail 'MediaTek retained x86 EXPAND_ROOT state'
fi

printf 'EXPAND_ROOT=1\n' > "$feature_file"

sh "$script" \
	--feature-file "$feature_file" \
	--board mediatek \
	--arch aarch64_cortex-a53 \
	--rootfs-size 512

[ ! -e "$feature_file" ] || fail 'empty generated product feature file was retained'

printf '%s\n' 'PASS: product feature state follows the selected target'
