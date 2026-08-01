# FanchmWrt build customizations

This directory holds FanchmWrt-specific build customizations that are not
OpenWrt package definitions.

- `overlays/feeds/` contains files merged into the checked-out feed tree.
- `scripts/apply-feeds-overlays.sh` copies those overlays into the build's
  `feeds/` directory.
- `tests/test-apply-feeds-overlays.sh` verifies that the overlay script merges
  files safely and that the Makefile invokes it as a separate recipe command.

## Updating the external feed pin

Resolve the current `main` revision through a direct Git connection without
setting a proxy:

```sh
git -c http.proxy= -c https.proxy= ls-remote \
  https://github.com/fanchmwrt/fanchmwrt-packages.git refs/heads/main
```

Use the returned 40-character commit ID to replace only the revision after
`^` in the `src-git fanchmwrt` line in `feeds.conf.default`. Review the diff
and run the focused overlay test before committing the pin update.
