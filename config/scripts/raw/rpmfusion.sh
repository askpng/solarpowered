#!/usr/bin/env bash

set -euo pipefail

rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

rpm-ostree update \
  --uninstall $(rpm -q rpmfusion-free-release) \
  --uninstall $(rpm -q rpmfusion-nonfree-release) \
  --install rpmfusion-free-release \
  --install rpmfusion-nonfree-release