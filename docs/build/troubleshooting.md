# 构建与 Feed 故障排查

排障时先保留命令、完整错误输出、当前提交、目标 Profile 和 `.config` 的相关片段。不要只提供截图或“编译失败”的概述。

## 常见检查顺序

1. 确认使用 Linux 构建环境，并记录发行版与依赖安装情况。
2. 按[快速开始](quick-start.md)中的显式直连命令重新执行 feeds 更新和安装，确认外部 feed 固定版本未被意外修改。
3. 先运行 `make target/linux/compile V=s` 生成选定目标内核的配置和构建产物，再用 `make package/fanchmwrt/fwx/compile V=s` 或 `make package/fanchmwrt/fwxd/compile V=s` 缩小到自有软件包；`fwx` 内核模块依赖这个内核前置步骤。
4. 对于 LuCI 软件源、WireGuard 或端口策略问题，附上可脱敏的配置、日志和复现步骤；不要把报告者的推测当作根因。

## 跨项目移植

将 FanchmWrt 组件移植到不同 OpenWrt 分支或内核时，内核接口、补丁和依赖版本都可能不同。此类问题应单独说明目标分支与内核版本，不能直接推定为本仓库的构建回归。

## 提交支持信息

需要协助时，请依照[支持说明](../../SUPPORT.md)提供最小复现材料，并避免公开敏感配置或凭据。

返回 [文档首页](../README.md)。
