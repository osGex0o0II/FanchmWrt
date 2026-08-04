#!/bin/sh
# fwx_setup_sync.sh - FanchmWrt 出厂安全状态同步
#
# 消除"已知默认口令 / 空密码免密登录"的出厂攻击面：
# - root 密码为空时：标记 fwx.global.setup_mode=1，并关闭 dropbear 密码认证。
#   （OpenWrt 自带 600-allow-blank-root-password.patch，root 空密码即免密 SSH，
#    故必须显式关闭，避免空密码免密登录。）
# - root 密码已设置后：标记 setup_mode=0，恢复 dropbear 密码认证。
#
# 用法: fwx_setup_sync.sh [now]
#   now = 状态发生变化时立即重启 dropbear（供 init/脚本调用）
. /lib/functions.sh

root_pw=$(awk -F: '$1=="root"{print $2; exit}' /etc/shadow)

if [ -z "$root_pw" ] || [ "$root_pw" = "*" ] || [ "$root_pw" = "!" ]; then
	uci set fwx.global.setup_mode='1'
	if [ "$(uci -q get dropbear.@dropbear[0].PasswordAuth)" != "off" ]; then
		uci set dropbear.@dropbear[0].PasswordAuth='off'
		uci set dropbear.@dropbear[0].RootPasswordAuth='off'
		uci commit dropbear
		[ "$1" = "now" ] && /etc/init.d/dropbear restart >/dev/null 2>&1
	fi
else
	uci set fwx.global.setup_mode='0'
	if [ "$(uci -q get dropbear.@dropbear[0].PasswordAuth)" != "on" ]; then
		uci set dropbear.@dropbear[0].PasswordAuth='on'
		uci set dropbear.@dropbear[0].RootPasswordAuth='on'
		uci commit dropbear
		[ "$1" = "now" ] && /etc/init.d/dropbear restart >/dev/null 2>&1
	fi
fi

uci commit fwx
exit 0
