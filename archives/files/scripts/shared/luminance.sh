#!/usr/bin/env bash

set -euo pipefail

# find latest version of luminance
LATEST_VERSION=$(curl https://api.github.com/repos/sidevesh/Luminance/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")

# download & install latest version of luminance
rpm-ostree install https://github.com/sidevesh/Luminance/releases/latest/download/luminance-${LATEST_VERSION}.rpm