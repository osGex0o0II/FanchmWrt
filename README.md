<p align="center">
  <img src="package/fanchmwrt/luci-theme-fanchmwrt/htdocs/luci-static/fanchmwrt/logo.svg" alt="FanchmWrt" width="160">
</p>

<h1 align="center">FanchmWrt</h1>

<p align="center">基于 OpenWrt 构建体系、将网络策略与 LuCI 定制明确分层的开源固件构建项目。</p>

<p align="center">
  <a href="docs/getting-started/download-and-flash.md">下载与刷写</a> ·
  <a href="docs/README.md">文档中心</a> ·
  <a href="docs/build/quick-start.md">构建指南</a> ·
  <a href="SUPPORT.md">获取支持</a> ·
  <a href="CONTRIBUTING.md">参与贡献</a>
</p>

## 从这里开始

- 初次接触项目：阅读[项目概览](docs/getting-started/overview.md)与[支持边界](docs/getting-started/supported-devices.md)。
- 准备刷写：先核对设备、镜像 Profile 和分区布局，再阅读[下载与刷写](docs/getting-started/download-and-flash.md)。
- 准备编译：从[构建环境](docs/build/environment.md)开始，Ubuntu 22.04 是推荐环境。
- 需要维护定制内容：参阅[定制层架构](docs/architecture/customization-layer.md)与[软件包和设备开发](docs/development/package-and-device-work.md)。

## FanchmWrt 定制能力

以下能力由仓库内的 FanchmWrt 软件包、覆盖层或 LuCI 主题承担；实际是否进入某个镜像取决于所选配置。

- **网络与设备管理**：`fwx` 内核模块与 `fwxd` 用户态组件构成网络策略和运行时管理的基础。
- **应用策略**：`fwxd` 的应用分类和策略配置为按应用维度的网络控制提供构建输入。
- **仪表盘与历史**：LuCI 相关组件可为状态展示与历史记录类功能提供界面接入；具体功能以启用的软件包为准。
- **LuCI 主题**：`luci-theme-fanchmwrt` 提供 FanchmWrt 的本地主题资源。

## 快速构建

在已准备好的 Linux 构建环境中执行：

```sh
env -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY \
  GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=http.proxy GIT_CONFIG_VALUE_0= \
  GIT_CONFIG_KEY_1=https.proxy GIT_CONFIG_VALUE_1= ./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
make -j"$(nproc)" V=s
```

完整的环境准备、feed 固定版本和故障排查说明见[构建文档](docs/build/quick-start.md)。Windows 工作区只用于静态检查；完整固件构建与刷写验收应在 Linux 环境完成。

## 兼容性提示

为消除出厂已知凭据与空密码免密登录的风险，当前定制层不再预置固定默认口令：`root` 出厂为空密码，系统在未设置 root 密码前**自动关闭 SSH 密码登录**（`dropbear`）并标记 `fwx.global.setup_mode=1`，首次登录请通过 LuCI 设置管理密码；设置完成后 SSH 自动恢复。默认无线网络可能处于开放状态，首次使用前请立即设置强加密或关闭无线访问；不应将默认状态用于生产网络。

## 许可

本项目采用 [GPL-2.0](LICENSES/GPL-2.0) 许可。OpenWrt 上游背景与同步边界见[项目概览](docs/getting-started/overview.md)。
