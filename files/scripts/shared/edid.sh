#!/usr/bin/env bash

set -euox pipefail

tee "/etc/dracut.conf.d/00-dp-2.conf" > /dev/null << 'EOF'
install_items+=" /lib/firmware/edid/edid.bin "
EOF