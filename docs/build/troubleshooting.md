# 构建与 Feed 故障排查

排障时先保留命令、完整错误输出、当前提交、目标 Profile 和 `.config` 的相关片段。不要只提供截图或“编译失败”的概述。

## 常见检查顺序

1. 确认使用 Linux 构建环境，并记录发行版与依赖安装情况。
2. 重新执行 `./scripts/feeds update -a` 和 `./scripts/feeds install -a`，确认外部 feed 固定版本未被意外修改。
3. 用 `make package/fwx/compile V=s` 或 `make package/fwxd/compile V=s` 缩小到自有软件包，再判断问题是否属于上游构建系统。
4. 对于 LuCI 软件源、WireGuard 或端口策略问题，附上可脱敏的配置、日志和复现步骤；不要把报告者的推测当作根因。

## 跨项目移植

将 FanchmWrt 组件移植到不同 OpenWrt 分支或内核时，内核接口、补丁和依赖版本都可能不同。此类问题应单独说明目标分支与内核版本，不能直接推定为本仓库的构建回归。

## 提交支持信息

需要协助时，请依照[支持说明](../../SUPPORT.md)提供最小复现材料，并避免公开敏感配置或凭据。

返回 [文档首页](../README.md)。
