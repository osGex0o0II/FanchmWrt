<h1 align="center">FanchmWrt</h1>

<p align="center">
  基于 OpenWrt 的路由系统源码分支，集成 FWX 网络识别与管理组件。
</p>

<p align="center">
  <a href="https://github.com/openwrt/openwrt"><img src="https://img.shields.io/badge/Base-OpenWrt-555555?style=flat-square" alt="OpenWrt" /></a>
  <a href="https://github.com/fanchmwrt/fanchmwrt-packages"><img src="https://img.shields.io/badge/Components-FWX-555555?style=flat-square" alt="FWX" /></a>
</p>

## 项目概述

本仓库是 [FanchmWrt](https://github.com/fanchmwrt/fanchmwrt) 的 Fork。FanchmWrt 基于 [OpenWrt](https://github.com/openwrt/openwrt)，在其构建系统中集成 FWX 相关组件及 LuCI 管理界面。

默认分支为 `fanchmwrt-25.12.6`。本仓库主要用于源码维护与设备适配，不代表 FanchmWrt 上游官方固件发布渠道。设备兼容性及刷写方式应以对应设备的构建与验证结果为准。

## 核心组件

默认路由器软件包配置（`include/target.mk`）包含：

- **FWX 服务与内核组件**：`fwxd`、`kmod-fwx`、`libfwx_common`。
- **Web 管理界面**：LuCI 与 `luci-theme-fanchmwrt`。
- **识别与统计界面**：`luci-app-fwx-appfilter`、`luci-app-fwx-session-stat`、`luci-app-fwx-traffic-stat` 等。

上述内容表示源码中的默认包配置，不保证所有目标设备均包含或完整支持相应功能。实际可用性取决于构建配置、组件依赖及设备环境。

## 构建说明

请在 Linux 环境中构建，并参考 [OpenWrt 构建环境要求](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem) 安装依赖。不同发行版的依赖名称和版本可能不同。

```sh
git clone --branch fanchmwrt-25.12.6 --single-branch https://github.com/osGex0o0II/FanchmWrt.git
cd FanchmWrt

./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make -j"$(nproc)"
```

在 `make menuconfig` 中选择目标平台、设备及所需软件包。编译结果通常位于 `bin/targets/` 下对应的目标目录。构建失败时，可使用 `make -j1 V=s` 获取详细日志。

`feeds.conf.default` 中部分 Feeds 固定到特定提交；执行 `feeds update -a` 不代表无条件使用各上游仓库的最新版本。

## 设备适配

设备支持以默认分支中的设备定义、实际固件构建结果及实机验证记录为准。

[ZN-M2 有线适配 PR #1](https://github.com/osGex0o0II/FanchmWrt/pull/1) 属于开发中的适配工作。在完成固件构建、实机启动、物理端口及升级恢复验证之前，不应将其视为已验证的正式固件支持。

## 上游与资源

- [FanchmWrt 上游源码](https://github.com/fanchmwrt/fanchmwrt)
- [OpenWrt 上游源码](https://github.com/openwrt/openwrt)
- [FanchmWrt 官网](https://www.fanchmwrt.com/)（上游项目资源，不代表本仓库的发布内容）

## 许可证与声明

OpenWrt 基础源码的 `COPYING` 文件标识为 `GPL-2.0-only`，并说明其他许可证可能适用。本仓库包含不同来源的组件；使用、修改或重新分发时，应分别核查对应文件和组件的许可证及版权声明。

上游 README 另有关于家长控制功能源码的使用声明。以下保留原文，避免改变其表述或适用范围：

<details>
<summary>上游使用声明（原文）</summary>

> The source code for the parental control feature in this project is intended for personal use only. It may not be used on behalf of a company, nor may it be integrated into any commercial router products for sale. While you are permitted to sell it in a personal capacity, you must retain the FanchmWrt copyright information.

</details>

请参阅 [仓库 COPYING](COPYING)、[许可证目录](LICENSES/) 及 [上游 README](https://github.com/fanchmwrt/fanchmwrt/blob/fanchmwrt-25.12.6/README.md)，确认适用的授权条款。
