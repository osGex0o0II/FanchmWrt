#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
expect_line() { grep -Fqx "$2" "$root/$1"; }
expect_text() { grep -Fq "$2" "$root/$1"; }
expect_line include/version.mk 'VERSION_NUMBER:=$(if $(VERSION_NUMBER),$(VERSION_NUMBER),25.12.5)'
expect_text package/base-files/image-config.in 'default "FanchmWrt"'
expect_text package/base-files/image-config.in 'default "https://downloads.openwrt.org/releases/25.12.5"'
expect_line feeds.conf.default 'src-git packages https://git.openwrt.org/feed/packages.git^5caa62e0bc9f7fb9b0c12a23267bceb7724214dd'
expect_line feeds.conf.default 'src-git fanchmwrt https://github.com/fanchmwrt/fanchmwrt-packages.git^fdfa9a6f8e02ab9ad10e2961271ba9a4fa872458'
