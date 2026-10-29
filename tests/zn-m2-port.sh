#!/bin/bash
set -eu
cd "$(dirname "$0")/.."
base=target/linux/qualcommax/ipq60xx/base-files
network=$(sed '/^\. /d; /^board_config_update/,$d' "$base/etc/board.d/02_network")
ucidef_set_interfaces_lan_wan() { printf 'interfaces:%s:%s\n' "$1" "$2"; }
eval "$network"
actual=$(ipq60xx_setup_interfaces zn,m2)
[[ "$actual" == 'interfaces:lan1 lan2 lan3:wan' ]] || { echo "FAIL network: $actual"; exit 1; }
source "$base/lib/upgrade/platform.sh"
board_name() { echo zn,m2; }
nand_do_upgrade() { echo "nand:$1"; }
default_do_upgrade() { echo "WRONG:default"; }
[[ "$(platform_do_upgrade fixture.bin)" == 'nand:fixture.bin' ]] || { echo 'FAIL NAND dispatch'; exit 1; }
ucidef_set_led_netdev() { printf '%s:%s\n' "$3" "$4"; }
board_config_update() { :; }
board_config_flush() { :; }
actual=$(sed '/^\. /d' "$base/etc/board.d/01_leds" | sed '$d' > /tmp/zn-m2-led-test-$$; source /tmp/zn-m2-led-test-$$; rm /tmp/zn-m2-led-test-$$)
[[ "$actual" == $'blue:lan:br-lan\nblue:wan:wan' ]] || { echo "FAIL LEDs: $actual"; exit 1; }
echo 'PASS real network, NAND dispatch and LED scripts with controlled shell fixtures'
