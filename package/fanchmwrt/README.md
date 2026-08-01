# FanchmWrt packages

This directory contains the FanchmWrt packages owned and built in this
OpenWrt tree. OpenWrt discovers them through its normal recursive
`package/` scan; their package names intentionally remain unchanged.

- `fwx` builds the FanchmWrt netfilter kernel module.
- `fwxd` builds and installs the FanchmWrt userspace daemon and its runtime
  configuration, init script, and utilities.
- `libfwx_common` builds the shared library used by FanchmWrt userspace
  components.
- `luci-theme-fanchmwrt` builds the FanchmWrt LuCI theme.

The separate `fanchmwrt` feed in `feeds.conf.default` supplies the external
FanchmWrt LuCI feed at a pinned revision. That feed is an input alongside
these in-tree packages; it is not a replacement for them.
