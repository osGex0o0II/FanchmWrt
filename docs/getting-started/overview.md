# 项目概览

FanchmWrt 在 OpenWrt 构建根目录上维护自己的软件包、feed 覆盖层和 LuCI 定制内容。项目不通过移动 OpenWrt 核心目录来实现定制：`config/`、`include/`、`scripts/`、`target/`、`toolchain/` 与 `tools/` 保持其原有职责。

## 先理解两个边界

1. **构建边界**：本仓库可按 OpenWrt 的 feeds、配置和 Makefile 流程构建；完整构建验证应在 Linux 环境完成。
2. **支持边界**：能否刷写取决于具体设备、目标、镜像 Profile、分区布局和升级路径，不应把某一镜像当作通用镜像。

## 推荐阅读顺序

1. 先阅读[支持边界](supported-devices.md)与[下载与刷写](download-and-flash.md)。
2. 需要自行构建时，阅读[构建环境](../build/environment.md)和[快速开始](../build/quick-start.md)。
3. 需要维护项目定制内容时，阅读[定制层架构](../architecture/customization-layer.md)。

## 上游关系

OpenWrt 提供构建系统和大部分基础软件包；FanchmWrt 的自有定制层则通过 `package/fanchmwrt/`、`fanchmwrt/` 和已固定版本的外部 feed 接入。贡献或排障时，应说明问题位于上游、外部 feed 还是本仓库的定制层。

返回 [文档首页](../README.md)。
