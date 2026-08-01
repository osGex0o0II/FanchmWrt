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
