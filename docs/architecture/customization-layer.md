# 定制层架构

FanchmWrt 的目录调整遵循一个原则：自有内容清晰分层，OpenWrt 核心目录保持兼容。这样既能定位定制输入，也不改变上游构建系统的预期布局。

```text
package/fanchmwrt/          树内 FanchmWrt 软件包
fanchmwrt/
  overlays/feeds/           需要合并到 feeds/ 的覆盖文件
  scripts/                  覆盖层应用脚本
  tests/                    覆盖层回归测试
docs/                       中文文档与维护说明
```

## 构建数据流

1. `feeds.conf.default` 固定外部 FanchmWrt feed 的提交版本。
2. OpenWrt 扫描 `package/fanchmwrt/` 中的树内软件包。
3. 根 Makefile 调用覆盖层脚本，把 `fanchmwrt/overlays/feeds/` 合并到 `feeds/`。
4. `menuconfig` 和 Make 目标根据当前配置选择软件包并生成镜像。

## 不应移动的核心目录

`config/`、`include/`、`scripts/`、`target/`、`toolchain/` 与 `tools/` 属于 OpenWrt 构建根的核心结构。FanchmWrt 定制应通过软件包、feed、覆盖层或文档接入，而不通过重命名这些目录实现。

返回 [文档首页](../README.md)。
