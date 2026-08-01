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

## Follow-up fix: separate the Makefile recipe command

### Fix

The `fwx_init` feature-update recipe ended with `fi ;\`, which caused the following tab-prefixed `@sh` line to be appended to the same shell command. The shell consequently received `@sh`, rather than Make interpreting `@` as recipe silencing. Removed only that trailing continuation marker so the explicit overlay invocation starts its own recipe command.

The existing focused shell test now also inspects the root `Makefile`: it requires the overlay invocation to begin with a tab-prefixed `@sh` recipe line and fails if the immediately preceding recipe line ends in a continuation backslash.

### TDD evidence

#### RED

Command:

```text
bash fanchmwrt/tests/test-apply-feeds-overlays.sh
```

Output (exit code 1, before the Makefile fix):

```text
FAIL: feed overlay command is continued into the preceding shell recipe
```

#### GREEN

Command:

```text
bash fanchmwrt/tests/test-apply-feeds-overlays.sh && sh -n fanchmwrt/scripts/apply-feeds-overlays.sh && sh -n fanchmwrt/tests/test-apply-feeds-overlays.sh && git diff --check
```

Output (exit code 0):

```text
PASS: feed overlays are merged safely
```

### Additional command attempted

```text
make -n fwx_init
```

This could not complete in the current Windows Git Bash environment (exit code 2) because the selected Windows `make.exe` passes repository paths such as `D:` to `cmd.exe` and prerequisite/config recipes then fail. The focused Makefile boundary assertion above does complete and verifies the reviewed defect directly.

### Follow-up self-review

- The test failed before the production edit for the reported continuation defect.
- The production change is limited to removing the one continuation character that merged two recipe commands.
- The test confirms both required parts of the integration contract: the overlay line is a recipe command (`@sh`) and its predecessor does not continue into it.
- The merge/preservation and missing-arguments tests remain covered by the same test script.
