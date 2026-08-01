# 构建环境

推荐使用 **Ubuntu 22.04** 进行完整构建。此仓库所在的 Windows 工作区可用于编辑、Shell 脚本和静态检查，但不作为完整固件构建验收环境。

## 准备原则

- 按当前 OpenWrt 构建系统要求安装依赖；不同发行版的软件包名称可能不同。
- 为源码、下载缓存和编译输出预留足够磁盘空间，并避免在网络共享目录中进行完整编译。
- 使用普通用户构建，保留完整日志；不要把凭据、私有源地址或设备密钥提交到仓库。

## 网络与依赖获取

项目的网络获取遵循直连原则。需要查看外部 FanchmWrt feed 的当前版本时，可显式清空 Git 代理配置：

```sh
git -c http.proxy= -c https.proxy= ls-remote \
  https://github.com/fanchmwrt/fanchmwrt-packages.git refs/heads/main
```

构建前请继续阅读[快速开始](quick-start.md)；feeds 的固定版本和覆盖层机制见[Feeds 与软件包](feeds-and-packages.md)。

返回 [文档首页](../README.md)。
