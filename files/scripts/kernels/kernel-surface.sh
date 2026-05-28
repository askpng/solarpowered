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

# Regenerate initramfs
VER=$(basename /usr/lib/modules/*)

export DRACUT_NO_XATTR=1
dracut --kver $VER --force --add ostree --no-hostonly --reproducible /usr/lib/modules/$VER/initramfs.img

# Clean up repo
rm /etc/yum.repos.d/linux-surface.repo