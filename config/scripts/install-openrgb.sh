#!/bin/bash
set -eu
set -o pipefail

# Download udev rules file
wget https://openrgb.org/releases/release_0.9/60-openrgb.rules

# Move udev rules file to udev rules directory
mv 60-openrgb.rules /usr/lib/udev/rules.d