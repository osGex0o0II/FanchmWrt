# FanchmWrt 构建定制层

此目录存放 FanchmWrt 自有、但不属于 OpenWrt 软件包定义的构建定制内容。

- `overlays/feeds/`：会合并到已检出 feed 树中的覆盖文件。
- `scripts/apply-feeds-overlays.sh`：将覆盖文件复制到构建目录的 `feeds/`。
- `tests/test-apply-feeds-overlays.sh`：验证覆盖脚本安全合并文件，并验证
  Makefile 将它作为独立配方命令调用。

## 更新外部 feed 固定版本

通过直连 Git、且不设置代理，解析 `main` 的当前版本：

```sh
git -c http.proxy= -c https.proxy= ls-remote \
  https://github.com/fanchmwrt/fanchmwrt-packages.git refs/heads/main
```

使用返回的 40 位提交 ID，只替换 `feeds.conf.default` 中
`src-git fanchmwrt` 行内 `^` 之后的版本号。提交该更新前，请审阅差异并运行
覆盖脚本的聚焦测试。

## Linux 构建验收

完整固件验收应在 Ubuntu 22.04 等 Linux 环境执行。以下命令覆盖 feeds、配置、
FanchmWrt 自有软件包和完整构建：

```sh
env -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY \
  GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=http.proxy GIT_CONFIG_VALUE_0= \
  GIT_CONFIG_KEY_1=https.proxy GIT_CONFIG_VALUE_1= ./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make target/linux/compile V=s
make package/fanchmwrt/fwx/compile V=s
make package/fanchmwrt/fwxd/compile V=s
make -j"$(nproc)" V=s
```

`make target/linux/compile V=s` 先生成选定目标内核的配置和构建产物，这是
`fwx` 内核模块能够通过软件包依赖检查的必要前置步骤。

Windows 工作区中的 Shell 与静态检查不能替代上述验收。
