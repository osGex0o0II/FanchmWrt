#!/bin/sh
set -eu

root_dir=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
script="$root_dir/fanchmwrt/scripts/apply-feeds-overlays.sh"
package_manager_call="$root_dir/fanchmwrt/overlays/feeds/luci/applications/luci-app-package-manager/root/usr/libexec/package-manager-call"
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT HUP INT TERM

source_dir="$temp_dir/source"
destination_dir="$temp_dir/destination"
mkdir -p "$source_dir/luci" "$destination_dir"
printf 'overlay\n' > "$source_dir/luci/file"
printf 'preserve\n' > "$destination_dir/keep"

"$script" --source "$source_dir" --destination "$destination_dir"

[ -f "$destination_dir/luci/file" ] && cmp -s "$source_dir/luci/file" "$destination_dir/luci/file"
[ -f "$destination_dir/keep" ] && printf 'preserve\n' | cmp -s - "$destination_dir/keep"

expect_rejected() {
  if "$@" >/dev/null 2>&1; then
    echo "FAIL: invalid invocation succeeded: $*" >&2
    exit 1
  fi
}

expect_rejected "$script"
expect_rejected "$script" --source "$source_dir"
expect_rejected "$script" --destination "$destination_dir"

if grep -F -- '--allow-untrusted' "$package_manager_call" >/dev/null; then
  echo 'FAIL: LuCI package manager bypasses APK package trust' >&2
  exit 1
fi

awk '
  /^fwx_init:/ { in_fwx_init = 1; next }
  in_fwx_init && /^[^[:space:]#][^:]*:/ { in_fwx_init = 0 }
  in_fwx_init && /^\t@sh ".*apply-feeds-overlays\.sh"/ {
    overlay_recipe = 1
    if (previous ~ /\\[[:space:]]*$/)
      continued_recipe = 1
  }
  /^prereq:/ && /(^|[[:space:]])fwx_init([[:space:]]|$)/ { prereq_depends_on_fwx_init = 1 }
  /^\.PHONY:/ && /(^|[[:space:]])fwx_init([[:space:]]|$)/ { fwx_init_is_phony = 1 }
  { previous = $0 }
  END {
    if (!overlay_recipe) { print "FAIL: fwx_init does not run the feed overlay command" > "/dev/stderr"; failed = 1 }
    if (continued_recipe) { print "FAIL: feed overlay command is continued into the preceding shell recipe" > "/dev/stderr"; failed = 1 }
    if (!prereq_depends_on_fwx_init) { print "FAIL: prereq does not depend on fwx_init" > "/dev/stderr"; failed = 1 }
    if (!fwx_init_is_phony) { print "FAIL: fwx_init is not phony" > "/dev/stderr"; failed = 1 }
    exit failed
  }
' "$root_dir/Makefile"

echo 'PASS: feed overlays are merged safely'
