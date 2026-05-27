#!/usr/bin/env bash

set -euo pipefail

dnf -y install dnf-plugins-core --setopt=install_weak_deps=False

dnf -y config-manager setopt install_weak_deps=False

# Configure exclusion for Fedora mainline kernel
# glob* everything, we don't need other kernel- packages here
dnf -y config-manager setopt "fedora*".exclude="kernel kernel*"
dnf -y config-manager setopt "updates*".exclude="kernel kernel*"

# Remove Fedora mainline kernel & leftover files
dnf -y remove \
    kernel \
    kernel-*
rm -r -f /usr/lib/modules/*

# Enable repo
# dnf -y config-manager addrepo --from-repofile=https://pkg.surfacelinux.com/fedora/linux-surface.repo

# linux-surface kernel repo - use F43 repo until F44 repo is released
cat <<EOF > /etc/yum.repos.d/linux-surface.repo
[linux-surface]
name=linux-surface
baseurl=https://pkg.surfacelinux.com/fedora/f43/
enabled=1
skip_if_unavailable=1
gpgkey=https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc
gpgcheck=1
enabled_metadata=1
type=rpm-md
repo_gpgcheck=0
EOF

# Install kernel & iptsd
dnf -y install \
    kernel-surface \
    kernel-surface-modules-extra-matched \
    iptsd

# Temporary workaround until libwacom-surface is updated for F44
dnf -y swap libwacom-data libwacom-surface-data

# Load surface-related modules on boot
# Reference: https://github.com/LorbusChris/bluespin/blob/main/build_files/build.sh
cat <<EOF > /usr/lib/modules-load.d/surface.conf
# Only on AMD models
pinctrl_amd
# Surface Book 2
pinctrl_sunrisepoint
# For Surface Pro 7/Laptop 3/Book 3
pinctrl_icelake
# For Surface Pro 7+/Pro 8/Laptop 4/Laptop Studio
pinctrl_tigerlake
# For Surface Pro 9/Laptop 5
pinctrl_alderlake
# For Surface Pro 10/Laptop 6
pinctrl_meteorlake
# Only on Intel models
intel_lpss
intel_lpss_pci
# Add modules necessary for Disk Encryption via keyboard
surface_aggregator
surface_aggregator_registry
surface_aggregator_hub
surface_hid_core
8250_dw
# Surface Pro 7/Laptop 3/Book 3 and later
surface_hid
surface_kbd
EOF

# Regenerate initramfs
VER=$(basename /usr/lib/modules/*)

export DRACUT_NO_XATTR=1
dracut --kver $VER --force --add ostree --no-hostonly --reproducible /usr/lib/modules/$VER/initramfs.img

# Clean up repo
rm /etc/yum.repos.d/linux-surface.repo