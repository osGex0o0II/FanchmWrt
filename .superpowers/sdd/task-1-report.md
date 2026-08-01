# Task 1 report: explicit feed overlay mechanism

## Implementation

- Added `fanchmwrt/scripts/apply-feeds-overlays.sh`, which requires `--source` and `--destination`, validates the source, creates the destination if needed, and merges the source tree with `cp -R "$source_dir/." "$destination_dir/"` without deleting destination-only files.
- Added `fanchmwrt/tests/test-apply-feeds-overlays.sh`, covering both source-file merge/destination-file preservation and the no-arguments failure path.
- Moved the package-manager overlay with `git mv` to `fanchmwrt/overlays/feeds/luci/applications/luci-app-package-manager/root/usr/libexec/package-manager-call`.
- Replaced Makefile's implicit `cp feeds_patches/* feeds/ -fr` with the explicit overlay script invocation in `fwx_init`.

## TDD evidence

### RED

Command:

```text
bash fanchmwrt/tests/test-apply-feeds-overlays.sh
```

Output (exit code 127, before the script existed):

```text
fanchmwrt/tests/test-apply-feeds-overlays.sh: line 15: /d/Code/Git/FanchmWrt/.worktrees/docs-restructure/fanchmwrt/scripts/apply-feeds-overlays.sh: No such file or directory
```

### GREEN

Command:

```text
bash fanchmwrt/tests/test-apply-feeds-overlays.sh
```

Output (exit code 0):

```text
PASS: feed overlays are merged safely
```

## Verification commands

```text
bash fanchmwrt/tests/test-apply-feeds-overlays.sh && git diff --check && sh -n fanchmwrt/scripts/apply-feeds-overlays.sh && sh -n fanchmwrt/tests/test-apply-feeds-overlays.sh
```

Exit code: `0`

Output:

```text
PASS: feed overlays are merged safely
```

## Changed files

- `Makefile`
- `fanchmwrt/scripts/apply-feeds-overlays.sh`
- `fanchmwrt/tests/test-apply-feeds-overlays.sh`
- `fanchmwrt/overlays/feeds/luci/applications/luci-app-package-manager/root/usr/libexec/package-manager-call` (moved from `feeds_patches/...` using `git mv`)
- `.superpowers/sdd/task-1-report.md`

## Self-review

- The test exercises the script as a real executable and verifies the requested merge and preservation behavior.
- The negative test confirms a no-arguments invocation fails.
- The script uses the requested argument interface and preserves destination-only files because it performs no deletion.
- The Makefile references only the new custom-layer overlay path; OpenWrt core layout was not moved or changed.
- `git diff --check` and shell syntax checks passed.

## Concerns

None.
