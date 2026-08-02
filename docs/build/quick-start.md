# 快速开始构建

以下步骤假设你已在 Ubuntu 22.04 等 Linux 构建环境中准备好 OpenWrt 所需依赖。首次构建、切换分支或调整 feed 固定版本后，应重新检查配置与日志。

## 标准步骤

```sh
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make defconfig
make package/fanchmwrt/fwx/compile V=s
make package/fanchmwrt/fwxd/compile V=s
make -j"$(nproc)" V=s
```

`make menuconfig` 用于选择目标、设备 Profile 和软件包；`make defconfig` 会根据当前选择补全默认配置。前两条软件包编译命令用于较早发现 FanchmWrt 自有组件的问题，最后一条才执行完整构建。

## 验收范围

构建成功不自动意味着可刷写。刷写前仍须核对设备、Profile 和分区布局。Windows 环境的 Shell 或静态检查不能替代此 Linux 构建验收。

## 继续阅读

外部 feed 固定版本、树内软件包和覆盖层的职责见[Feeds 与软件包](feeds-and-packages.md)；出现构建问题时，按[故障排查](troubleshooting.md)保留日志。

返回 [文档首页](../README.md)。
