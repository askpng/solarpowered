#!/usr/bin/env bash

set -x

# Remove Fedora kernel & remove leftover files
dnf -y remove \
    kernel \
    kernel-* && \
rm -r -f /usr/lib/modules/*

# Install dnf-plugins-core just in case
dnf -y install --setopt=install_weak_deps=False \
    dnf-plugins-core \
    dnf5-plugins

# Configure exclusion
dnf -y config-manager setopt "*fedora*".exclude=" \
    kernel \
    kernel-core \
    kernel-modules \
    kernel-modules-core \
    kernel-modules-extra \
    kernel-headers \
    "
# Add linux-surface kernel & terra subatomic repo
dnf -y config-manager addrepo \
    --from-repofile=https://pkg.surfacelinux.com/fedora/linux-surface.repo

# Install akmods, kernel, and modules
dnf -y install --setopt=install_weak_deps=False --allowerasing \
    kernel-surface \
    iptsd \
    libwacom-surface

# Clean up repos from earlier
rm -f /etc/yum.repos.d/{*surface*}.repo