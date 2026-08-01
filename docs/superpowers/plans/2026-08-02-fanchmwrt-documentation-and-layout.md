# FanchmWrt Documentation and Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Chinese-first project entry point and make FanchmWrt custom build inputs explicit without moving OpenWrt core directories.

**Architecture:** Keep the OpenWrt buildroot layout intact. Put FanchmWrt-owned feed overlays and their application script under `fanchmwrt/`, keep in-tree packages under `package/fanchmwrt/`, and document all user-facing workflows under `docs/`.

**Tech Stack:** Markdown, YAML issue forms, POSIX shell, GNU Make, OpenWrt feeds.

## Global Constraints

- Do not move or rename `config/`, `include/`, `scripts/`, `target/`, `toolchain/`, or `tools/`.
- Do not claim a firmware, device, CI status, support email, funding method, or security channel that is not verifiable from this repository.
- Keep package discovery under `package/` and invoke feed overlays through the root Makefile.
- Use Chinese as the default documentation language.
- Full firmware validation is a Linux-only acceptance criterion; this Windows workspace can run shell-script and static checks only.

---

### Task 1: Create and test the explicit feed-overlay mechanism

**Files:**
- Create: `fanchmwrt/scripts/apply-feeds-overlays.sh`
- Create: `fanchmwrt/tests/test-apply-feeds-overlays.sh`
- Move: `feeds_patches/luci/applications/luci-app-package-manager/root/usr/libexec/package-manager-call` to `fanchmwrt/overlays/feeds/luci/applications/luci-app-package-manager/root/usr/libexec/package-manager-call`
- Modify: `Makefile:96-106`

**Interfaces:**
- Consumes: `--source <directory>` and `--destination <directory>`.
- Produces: A merged destination tree; no deletion of destination-only files.

- [ ] **Step 1: Write the failing shell test**

Create a test that creates temporary `source` and `destination` directories, places `luci/file` only in source and `keep` only in destination, runs the script, then asserts both files exist. Add a negative test that runs the script without arguments and expects a non-zero exit status.

- [ ] **Step 2: Run the test before implementation**

Run: `bash fanchmwrt/tests/test-apply-feeds-overlays.sh`

Expected: FAIL because `fanchmwrt/scripts/apply-feeds-overlays.sh` does not exist.

- [ ] **Step 3: Implement the script**

```sh
#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 --source <directory> --destination <directory>" >&2
  exit 2
}

source_dir=
destination_dir=

while [ "$#" -gt 0 ]; do
  case "$1" in
    --source) source_dir=${2:-}; shift 2 ;;
    --destination) destination_dir=${2:-}; shift 2 ;;
    *) usage ;;
  esac
done

[ -n "$source_dir" ] && [ -n "$destination_dir" ] || usage
[ -d "$source_dir" ] || { echo "Overlay source does not exist: $source_dir" >&2; exit 1; }
mkdir -p "$destination_dir"
cp -R "$source_dir/." "$destination_dir/"
```

- [ ] **Step 4: Replace the implicit copy and move the overlay source**

Replace the `cp feeds_patches/* feeds/ -fr` line in `fwx_init` with:

```make
	@sh "$(TOPDIR)/fanchmwrt/scripts/apply-feeds-overlays.sh" \
		--source "$(TOPDIR)/fanchmwrt/overlays/feeds" \
		--destination "$(TOPDIR)/feeds"
```

Use `git mv` for the existing overlay file so its history is preserved.

- [ ] **Step 5: Run the shell test and Makefile static check**

Run: `bash fanchmwrt/tests/test-apply-feeds-overlays.sh`

Expected: `PASS: feed overlays are merged safely`.

Run: `git diff --check`.

Expected: exit 0.

### Task 2: Make FanchmWrt-owned source paths and feed inputs explicit

**Files:**
- Move: `package/fcm/` to `package/fanchmwrt/`
- Create: `package/fanchmwrt/README.md`
- Create: `fanchmwrt/README.md`
- Modify: `feeds.conf.default:6`

**Interfaces:**
- Consumes: the OpenWrt recursive `package/` scanner and the exact FanchmWrt feed commit.
- Produces: descriptive package ownership and reproducible feed input.

- [ ] **Step 1: Capture the external feed commit**

Run: `git ls-remote https://github.com/fanchmwrt/fanchmwrt-packages.git refs/heads/main`

Use the returned 40-character SHA in `feeds.conf.default` as `src-git fanchmwrt <url>^<sha>`.

- [ ] **Step 2: Rename the in-tree vendor directory**

Run: `git mv package/fcm package/fanchmwrt`.

Do not alter package names (`fwx`, `fwxd`, `libfwx_common`, `luci-theme-fanchmwrt`) because package dependencies use those names.

- [ ] **Step 3: Add ownership documentation**

`package/fanchmwrt/README.md` must list the four packages, their build role, and their relationship to the external LuCI feed. `fanchmwrt/README.md` must explain the overlay directory, script, tests, and feed pin update procedure.

- [ ] **Step 4: Prove no stale paths remain**

Run: `git grep -nE 'feeds_patches|package/fcm' -- ':!docs/superpowers/**'`.

Expected: no output.

Run: `git diff --check`.

Expected: exit 0.

### Task 3: Build the Chinese documentation system and README Hero

**Files:**
- Modify: `README.md`
- Create: `docs/README.md`
- Create: `docs/getting-started/overview.md`
- Create: `docs/getting-started/supported-devices.md`
- Create: `docs/getting-started/download-and-flash.md`
- Create: `docs/build/environment.md`
- Create: `docs/build/quick-start.md`
- Create: `docs/build/feeds-and-packages.md`
- Create: `docs/build/troubleshooting.md`
- Create: `docs/usage/basic-mode.md`
- Create: `docs/architecture/customization-layer.md`
- Create: `docs/development/package-and-device-work.md`
- Create: `docs/maintenance/release-and-support.md`
- Create: `docs/assets/README.md`

**Interfaces:**
- Consumes: the local logo at `package/fanchmwrt/luci-theme-fanchmwrt/htdocs/luci-static/fanchmwrt/logo.svg` and canonical documentation paths.
- Produces: a Chinese-first navigation graph rooted at `README.md` and `docs/README.md`.

- [ ] **Step 1: Replace the README with a compact Chinese Hero**

Include a local logo, a one-sentence positioning statement, links to download, documentation, build guide, support, and contribution guidance. Include capability headings only for behavior backed by the FanchmWrt packages: network/device management, application policy, dashboard/history, and LuCI theme. Keep the build snippet to feeds update, feeds install, menuconfig, and `make -j"$(nproc)" V=s`.

- [ ] **Step 2: Write the detailed document pages**

Every page must begin with a Chinese H1 and end with a link back to `docs/README.md`. The build pages must state that Ubuntu 22.04 is recommended and that feed pins must be updated intentionally. The flashing page must require matching device/profile/partition layout and direct uncertain users to documentation rather than implying a universal flashing command.

- [ ] **Step 3: Validate Markdown navigation**

Run a script or PowerShell check that extracts relative Markdown links in the created files and fails if a local target is missing. Manually render the root README through GitHub-compatible Markdown preview or inspect all relative asset paths.

### Task 4: Replace inherited project-governance entry points

**Files:**
- Create: `CONTRIBUTING.md`
- Create: `SUPPORT.md`
- Create: `SECURITY.md`
- Create: `.github/README.md`
- Modify: `.github/ISSUE_TEMPLATE/bug-report.yml`
- Create: `.github/ISSUE_TEMPLATE/feature-request.yml`
- Create: `.github/ISSUE_TEMPLATE/device-support.yml`
- Modify: `.github/ISSUE_TEMPLATE/config.yml`
- Modify: `.github/pull_request_template`
- Delete: `.github/FUNDING.yml`

**Interfaces:**
- Consumes: GitHub Issue Form YAML and the root support documents.
- Produces: Chinese issue, feature, device, and contribution paths that do not redirect users to OpenWrt as if it were FanchmWrt support.

- [ ] **Step 1: Create governance documents**

`CONTRIBUTING.md` must require a focused change, rationale, test evidence, and no unrelated formatting. `SUPPORT.md` must explain supported questions, required device/version/log information, and scope boundaries. `SECURITY.md` must prohibit public disclosure of sensitive proof-of-concepts and direct users to GitHub private vulnerability reporting when available; it must not invent an email address.

- [ ] **Step 2: Localize Issue Forms**

Use only verified labels: `bug`, `enhancement`, and `question`. Create separate Chinese forms for bug reports, feature requests, and device support. Set `blank_issues_enabled: false` and remove inherited OpenWrt contact links.

- [ ] **Step 3: Replace stale PR/Funding metadata**

Rewrite the PR template in Chinese with purpose, scope, test, and compatibility sections. Delete `.github/FUNDING.yml` because its only target is OpenWrt and no FanchmWrt funding method is verified. Add `.github/README.md` to distinguish inherited workflows from FanchmWrt-owned governance files.

- [ ] **Step 4: Validate YAML and stale references**

Run: `git grep -n 'openwrt.org/donate' .github`

Expected: no output.

Run: `git diff --check`.

Expected: exit 0.

### Task 5: Perform repository-level verification and commits

**Files:**
- Verify: all files changed by Tasks 1-4

- [ ] **Step 1: Run static checks**

Run the overlay shell test, stale-path search, stale-funding search, Markdown link check, YAML parse check, `git diff --check`, and `git status --short`.

- [ ] **Step 2: Record Linux acceptance commands**

Document these commands in `docs/build/quick-start.md` and `fanchmwrt/README.md`:

```sh
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make package/fwx/compile V=s
make package/fwxd/compile V=s
make -j"$(nproc)" V=s
```

- [ ] **Step 3: Commit coherent change sets**

Create separate commits for: feed overlay/path governance, Chinese documentation/Hero, and GitHub governance. Use `git status --short` after each commit.
