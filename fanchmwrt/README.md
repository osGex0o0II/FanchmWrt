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
