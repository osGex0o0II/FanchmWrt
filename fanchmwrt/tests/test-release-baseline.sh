#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
expect_line() { grep -Fqx "$2" "$root/$1"; }
expect_stanza_default() {
	awk -v stanza="$2" -v value="$3" '
		/^[[:space:]]*config[[:space:]]+/ { in_stanza = ($2 == stanza); next }
		in_stanza && $1 == "default" && $2 == sprintf("\"%s\"", value) { found = 1 }
		END { exit !found }
	' "$root/$1"
}
expect_line include/version.mk 'VERSION_NUMBER:=$(if $(VERSION_NUMBER),$(VERSION_NUMBER),25.12.5)'
expect_stanza_default package/base-files/image-config.in VERSION_DIST FanchmWrt
expect_stanza_default package/base-files/image-config.in VERSION_REPO https://downloads.openwrt.org/releases/25.12.5
resolved_dist=$(
	make -s --no-print-directory TOPDIR="$root" DUMP=1 CONFIG_VERSION_DIST= print -f - <<'EOF'
include $(TOPDIR)/rules.mk
include $(TOPDIR)/include/version.mk

.PHONY: print
print:
	@printf '%s\n' "$(VERSION_DIST)"
EOF
)
[ "$resolved_dist" = FanchmWrt ]
grep -Fq 'root/password' "$root/README.md"
expected_feeds=$(mktemp "${TMPDIR:-/tmp}/fanchmwrt-feeds.XXXXXX")
trap 'rm -f "$expected_feeds"' 0 HUP INT TERM
cat >"$expected_feeds" <<'EOF'
src-git packages https://git.openwrt.org/feed/packages.git^5caa62e0bc9f7fb9b0c12a23267bceb7724214dd
src-git luci https://git.openwrt.org/project/luci.git^128a7812f4be233c5dd7f7466f534fd888785caf
src-git routing https://git.openwrt.org/feed/routing.git^3d7d0dc7fa43d3eb09498417407e95a6552e5312
src-git telephony https://git.openwrt.org/feed/telephony.git^2618106d5846a4a542fdf5809f0d3ed228ce439b
src-git video https://github.com/openwrt/video.git^094bf58da6682f895255a35a84349a79dab4bf95
src-git fanchmwrt https://github.com/fanchmwrt/fanchmwrt-packages.git^fdfa9a6f8e02ab9ad10e2961271ba9a4fa872458
EOF
cmp -s "$expected_feeds" "$root/feeds.conf.default"
