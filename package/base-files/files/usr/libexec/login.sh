#!/bin/sh
# FanchmWrt 快速上手菜单仅在交互式终端启用，避免非交互会话
# （SSH 命令执行、scp/sftp、脚本）被其无限刷新循环阻塞
if [ -t 0 ]; then
	/usr/bin/fwx_cli.sh
fi
[ -t 0 ] && {
	tty_dev=$(readlink /proc/self/fd/0)
	case "$tty_dev" in
		/dev/console|/dev/tty[0-9]*)
			export TERM=${TERM:-linux}
			;;
		/dev/*)
			export TERM=vt102
			;;
	esac
}

[ "$(uci -q get system.@system[0].ttylogin)" = 1 ] || exec /bin/login -f root

exec /bin/login
