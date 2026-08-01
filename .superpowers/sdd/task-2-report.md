# Task 2 report: explicit FanchmWrt sources and feed input

## Changes

- Moved the FanchmWrt-owned package tree from `package/fcm/` to
  `package/fanchmwrt/` with `git mv`. The four package names are unchanged:
  `fwx`, `fwxd`, `libfwx_common`, and `luci-theme-fanchmwrt`.
- Pinned the external `fanchmwrt` feed in `feeds.conf.default` to
  `fdfa9a6f8e02ab9ad10e2961271ba9a4fa872458`.
- Added ownership and maintenance documentation in the two required README
  files.

## Direct-network feed resolution

Command:

```text
git -c http.proxy= -c https.proxy= ls-remote https://github.com/fanchmwrt/fanchmwrt-packages.git refs/heads/main
```

Output (exit code 0):

```text
fdfa9a6f8e02ab9ad10e2961271ba9a4fa872458	refs/heads/main
```

The command explicitly clears Git's HTTP and HTTPS proxy settings for this
invocation; no proxy was configured or used.

## Verification

```text
bash fanchmwrt/tests/test-apply-feeds-overlays.sh
PASS: feed overlays are merged safely

PowerShell feed-pin validation against ^src-git fanchmwrt … ^[0-9a-f]{40}$
PASS: pinned fanchmwrt revision is 40 hexadecimal characters

git diff --check
(exit code 0; no output)

git diff --cached --check
(exit code 0; no output)

git diff HEAD^ HEAD --check
(exit code 0; no output)
```

The brief's requested stale-path command was also run:

```text
git grep -nE 'feeds_patches|package/fcm' -- ':!docs/superpowers/**'
```

It returns only report references: two in the pre-existing tracked
`.superpowers/sdd/task-1-report.md` historical report and three in this report
(which records the requested command and moved path). No non-report source or
documentation path contains either stale name. The requested exclusion is
`docs/superpowers/**`, while the repository stores these task reports under
`.superpowers/sdd/`; therefore the expected empty result cannot hold without
rewriting historical reports or correcting the exclusion. Adding
`':!.superpowers/**'` to the pathspec produces no output (Git exit code 1),
which confirms no stale source path remains.

## Changed files

- `feeds.conf.default`
- `package/fanchmwrt/` (the complete tree moved from `package/fcm/`)
- `package/fanchmwrt/README.md`
- `fanchmwrt/README.md`
- `.superpowers/sdd/task-2-report.md`

## Concerns

The stale-path verification discrepancy above remains: its exact command
includes tracked historical task reports despite excluding a different
directory.
