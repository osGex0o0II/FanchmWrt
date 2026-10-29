# ZN-M2 wired-only native port

Baseline: e1a6e69417cd413aa1e5207f29a98e65ee680c10 (25.12.6).
Board wiring and image geometry originate from bfe945deb96f6e18bd733e35a452d106a8fee37e; unrelated board changes are excluded.

Use config/zn-m2-wired.config as the seed, then run make defconfig in a supported Linux build environment. The zn_m2 image profile retains native FanchmWrt LuCI theme and FWX applications. No replacement UI or proxy suite is added.

Only stock 256 MiB wired operation is intended. WiFi and WCSS are disabled, as are the board USB PHY/controller nodes. The Q6 reservation is reduced to 16 MiB at 0x4ab00000; the upstream 16 MiB NSS reservation remains untouched for platform stability. DRAM discovery remains the bootloader responsibility, rather than declaring an invented fixed memory bank.

Physical PHY addresses 0/1/3/4 map to lan1/lan2/lan3/wan; ESS port 3 remains disabled. NAND uses the original SMEM partition parser and 128 KiB erase/2048-byte page image geometry. No ART partition or MAC address is rewritten; the prior native board relies on the platform/bootloader MAC assignment. Network defaults create three LAN members and a separate WAN. The upgrade dispatcher selects the existing NAND upgrade implementation. This is not evidence that OEM installation or cross-firmware migration is safe.

Validation: bash tests/zn-m2-port.sh executes the production network functions, upgrade function, and LED script with controlled shell functions replacing UCI/flash operations. It asserts exact LAN/WAN selection, NAND dispatch with the original filename, and wired LED devices. No flash command runs. Removing the board cases makes these assertions fail. Captured RED and GREEN output lives under .omo/evidence/zn-m2/.

Outstanding release gates: patched kernel DTS preprocessing and dtc, resolved defconfig/package dependencies, full firmware build, stock-device boot, ART/MAC persistence, physical port and LED tests, recovery-backed upgrade, and memory soak. The local Windows shell tests do not establish any of those gates. No performance or acceleration claim is made.
