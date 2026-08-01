# FanchmWrt 文档与定制层治理设计

## 目标

将仓库从“OpenWrt 源码树附带少量品牌说明”整理为可理解、可复现、可维护的 FanchmWrt 发行版仓库，同时保持 OpenWrt 的构建目录与行为兼容。

## 现状与约束

- `README.md` 只有英文概述和通用编译命令，未说明 FanchmWrt 的功能层、支持边界或维护入口。
- `package/fcm/` 包含 FanchmWrt 的内核模块 `fwx`、守护进程 `fwxd`、公共库和 LuCI 主题；外部 `fanchmwrt-packages` feed 提供 LuCI 应用包。
- 根 `Makefile` 的 `fwx_init` 在构建前把 `feeds_patches/` 直接复制到 `feeds/`。该目录是 overlay 源，不是传统 patch 集。
- 上游 OpenWrt feed 固定了提交，但 `fanchmwrt-packages` feed 未固定提交，导致同一分支的构建输入可能随时间变化。
- `.github` 的 Issue、PR、Funding 与部分工作流仍引用 OpenWrt，不能代表 FanchmWrt 的支持与治理承诺。
- `config/`、`include/`、`package/`、`scripts/`、`target/`、`toolchain/`、`tools/` 是 OpenWrt 构建根目录，不能移动或改名。

## 范围

### 本次包含

1. 将根 README 改为中文 Hero 首页，并提供可信的用户、编译和贡献入口。
2. 新建中文 `docs/` 信息架构，覆盖入门、构建、使用、架构、维护与开发。
3. 增加中文贡献、支持与安全披露说明，替换继承自 OpenWrt 的 Issue、PR 与 Funding 入口。
4. 将 `feeds_patches/` 迁移为显式的 `fanchmwrt/overlays/feeds/`，以受测试的脚本注入 overlay。
5. 将 `package/fcm/` 改名为 `package/fanchmwrt/`，保留在 OpenWrt 的包扫描范围内。
6. 固定 `fanchmwrt-packages` feed 到当前已验证提交，并记录更新流程。

### 本次不包含

- 不移动或重写 OpenWrt 核心目录、内核、目标定义或基础文件修改。
- 不新建官网、发布固件、修改产品功能或替换继承的 CI 工作流。
- 不虚构安全邮箱、赞助地址、支持设备或构建状态。
- 不执行完整固件构建；当前 Windows 工作区不兼容 OpenWrt 的 Linux 构建前置条件。

## 目标结构

```text
README.md
docs/
  README.md
  getting-started/
  build/
  usage/
  architecture/
  development/
  maintenance/
  assets/
fanchmwrt/
  README.md
  overlays/feeds/
  scripts/apply-feeds-overlays.sh
  tests/test-apply-feeds-overlays.sh
package/fanchmwrt/
.github/
CONTRIBUTING.md
SUPPORT.md
SECURITY.md
```

## 文档设计

根 README 只承担项目首页职责：本地 Logo、中文定位、快速入口、能力摘要、三步编译、支持边界和文档导航。详细说明放入 `docs/`，避免首页变成维护成本高的百科。

`docs/` 以中文为默认语言；在需要英文时再增加独立语言目录，而不在首轮引入空的多语言骨架。内容必须明确区分“官方镜像用户”“自行编译者”“设备贡献者”和“代码贡献者”。

## 构建定制层设计

`fanchmwrt/overlays/feeds/` 是唯一的 feed overlay 源目录。`apply-feeds-overlays.sh` 接受明确的源和目标路径，创建目标目录、保留目标中无关文件，并复制 overlay 树。根 `Makefile` 通过 `sh` 调用该脚本，取代隐式的 `cp feeds_patches/* feeds/ -fr`。

外部 FanchmWrt feed 的提交固定在 `feeds.conf.default`；更新该提交时必须同步更新构建文档并在 Linux 环境运行 feeds、defconfig 与代表性目标编译。

## 验收标准

1. 所有 Markdown 内部链接和 README Logo 路径存在。
2. overlay 测试证明嵌套文件会复制、既有无关目标文件不会删除、缺少参数会失败。
3. 运行时源码、构建文件和用户文档中不再存在 `feeds_patches/` 或 `package/fcm/` 的有效路径引用；设计与历史记录可保留迁移说明。
4. `feeds.conf.default` 中所有 Git feed 都固定提交。
5. Git 工作区无未预期文件；Windows 环境限制被记录为 Linux 构建验收项。
