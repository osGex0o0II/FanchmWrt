#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
expect_line() { grep -Fqx "$2" "$root/$1"; }

expect_line fanchmwrt/configs/mediatek-filogic-stock.config 'CONFIG_TARGET_mediatek=y'
expect_line fanchmwrt/configs/mediatek-filogic-stock.config 'CONFIG_TARGET_mediatek_filogic=y'
expect_line fanchmwrt/configs/mediatek-filogic-stock.config 'CONFIG_TARGET_MULTI_PROFILE=y'
expect_line fanchmwrt/configs/mediatek-filogic-stock.config 'CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_h3c_magic-nx30-pro-stock=y'
expect_line fanchmwrt/configs/mediatek-filogic-stock.config 'CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_jcg_q30-pro-stock=y'
expect_line fanchmwrt/configs/x86-64.config 'CONFIG_TARGET_x86=y'
expect_line fanchmwrt/configs/x86-64.config 'CONFIG_TARGET_x86_64=y'
expect_line fanchmwrt/configs/x86-64.config 'CONFIG_TARGET_MULTI_PROFILE=y'
expect_line fanchmwrt/configs/x86-64.config 'CONFIG_TARGET_DEVICE_x86_64_DEVICE_generic=y'

for config in \
	fanchmwrt/configs/mediatek-filogic-stock.config \
	fanchmwrt/configs/x86-64.config
do
	expect_line "$config" 'CONFIG_VERSIONOPT=y'
	expect_line "$config" 'CONFIG_VERSION_DIST="FanchmWrt"'
	expect_line "$config" 'CONFIG_VERSION_REPO="https://downloads.openwrt.org/releases/25.12.5"'
done
