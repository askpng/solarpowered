#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Download udev rules file
wget https://openrgb.org/releases/release_0.9/60-openrgb.rules

# Move udev rules file to udev rules directory
mv 60-openrgb.rules /usr/lib/udev/rules.d