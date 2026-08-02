# FanchmWrt 文档中心

本文档以中文为默认语言，说明 FanchmWrt 的构建、定制、使用边界与维护流程。本文档描述的是当前仓库可核验的内容；设备兼容性、镜像可用性和具体功能应以所选分支、配置及发布说明为准。

## 入门

- [项目概览](getting-started/overview.md)：项目定位、上游关系与阅读顺序。
- [支持边界](getting-started/supported-devices.md)：设备、分区、内核和闭源驱动的核验原则。
- [下载与刷写](getting-started/download-and-flash.md)：刷写前必须完成的匹配检查。

## 构建

- [构建环境](build/environment.md)：推荐的 Ubuntu 22.04 环境与准备事项。
- [快速开始](build/quick-start.md)：从更新 feeds 到完整构建的命令顺序。
- [Feeds 与软件包](build/feeds-and-packages.md)：固定外部 feed、树内软件包和覆盖层。
- [故障排查](build/troubleshooting.md)：构建、feed 与日志问题的收集方式。

## 使用与定制

- [基础模式](usage/basic-mode.md)：在启用的镜像中核对基础网络和策略功能。
- [定制层架构](architecture/customization-layer.md)：`fanchmwrt/`、`package/fanchmwrt/` 与 OpenWrt 核心的边界。
- [软件包和设备开发](development/package-and-device-work.md)：新增或维护软件包、设备工作的约束。
- [发布与支持](maintenance/release-and-support.md)：发布前检查、支持信息和安全报告边界。

## 资产

- [文档资产约定](assets/README.md)：文档中图片与静态资源的引用原则。

你正在阅读 [文档首页](README.md)。
