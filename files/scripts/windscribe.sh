#!/usr/bin/env bash

set -euo pipefail

# find latest version of windscribe stable RPM
LATEST_VERSION=$(curl https://api.github.com/repos/Windscribe/Desktop-App/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")

# download & install latest version of windscribe stable RPM
rpm-ostree install https://github.com/Windscribe/Desktop-App/releases/latest/download/windscribe_${LATEST_VERSION}_x86_64_fedora.rpm