#!/bin/sh
set -eu

root_dir=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
script="$root_dir/fanchmwrt/scripts/apply-feeds-overlays.sh"
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT HUP INT TERM

source_dir="$temp_dir/source"
destination_dir="$temp_dir/destination"
mkdir -p "$source_dir/luci" "$destination_dir"
printf 'overlay\n' > "$source_dir/luci/file"
printf 'preserve\n' > "$destination_dir/keep"

"$script" --source "$source_dir" --destination "$destination_dir"

[ -f "$destination_dir/luci/file" ]
[ -f "$destination_dir/keep" ]

if "$script" >/dev/null 2>&1; then
  echo 'FAIL: invocation without arguments succeeded' >&2
  exit 1
fi

echo 'PASS: feed overlays are merged safely'
