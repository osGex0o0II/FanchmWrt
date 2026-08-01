# FanchmWrt 软件包

此目录包含由本 OpenWrt 源码树拥有并构建的 FanchmWrt 软件包。OpenWrt 会通过
常规的 `package/` 递归扫描发现它们；软件包名称刻意保持不变。

- `fwx`：构建 FanchmWrt 的 netfilter 内核模块。
- `fwxd`：构建并安装 FanchmWrt 用户态守护进程，以及运行时配置、初始化脚本和工具。
- `libfwx_common`：构建供 FanchmWrt 用户态组件使用的共享库。
- `luci-theme-fanchmwrt`：构建 FanchmWrt 的 LuCI 主题。

`feeds.conf.default` 中独立的 `fanchmwrt` feed 会以固定版本提供外部
FanchmWrt LuCI feed。它与这些树内软件包共同构成构建输入，并不替代它们。
