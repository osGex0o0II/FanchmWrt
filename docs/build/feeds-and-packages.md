# Feeds 与软件包

FanchmWrt 的构建输入分为三类：OpenWrt 自身的软件包与 feeds、树内的 FanchmWrt 软件包，以及已固定版本的外部 FanchmWrt LuCI feed。固定版本是可复现构建的一部分，不应在日常构建中悄然漂移。

## 树内软件包

`package/fanchmwrt/` 下的 `fwx`、`fwxd`、`libfwx_common` 和 `luci-theme-fanchmwrt` 由 OpenWrt 的 `package/` 递归扫描发现。它们的目录可表达归属，但软件包名保持不变，以免破坏依赖关系。

## 外部 feed 固定版本

`feeds.conf.default` 中的 `fanchmwrt` 条目使用 `^<commit>` 固定到一个 Git 提交。更新它时：

1. 通过直连 `git ls-remote` 取得 `main` 的 40 位提交 ID。
2. 只更新固定版本，审阅 feed 中的实际变更。
3. 运行 feeds 更新、聚焦的软件包测试和 Linux 构建验收，再提交该更新。

不要把“更新到最新”当作无风险操作；固定版本的变化应有明确理由和可复现证据。

## Feed 覆盖层

`fanchmwrt/overlays/feeds/` 保存需要覆盖到已检出 feed 树的文件。根 Makefile 通过 `fanchmwrt/scripts/apply-feeds-overlays.sh` 合并该目录；脚本只合并文件，不删除目标树中原有的其他文件。对应回归测试位于 `fanchmwrt/tests/test-apply-feeds-overlays.sh`。

返回 [文档首页](../README.md)。
