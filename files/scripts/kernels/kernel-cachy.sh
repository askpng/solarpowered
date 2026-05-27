#!/usr/bin/env bash

dnf -y install dnf-plugins-core --setopt=install_weak_deps=False

dnf -y config-manager setopt install_weak_deps=False

# Exclude Fedora mainline kernel
# Do not exclude kernel-headers here
# Exclude Fedora mainline kernel
dnf -y config-manager setopt "fedora*".exclude=" \
    kernel \
    kernel-devel \
    kernel-core* \
    kernel-debug* \
    kernel-devel* \
    kernel-modules* \
    kernel-tools* \
    "
dnf -y config-manager setopt "updates*".exclude=" \
    kernel \
    kernel-devel \
    kernel-core* \
    kernel-debug* \
    kernel-devel* \
    kernel-modules* \
    kernel-tools* \
    "

# Remove Fedora mainline kernel & leftover files
dnf -y remove \
    kernel \
    kernel-*
rm -r -f /usr/lib/modules/*

# Enable repos
dnf -y copr enable bieszczaders/kernel-cachyos-lto
dnf -y copr enable bieszczaders/kernel-cachyos-addons
dnf -y config-manager addrepo --from-repofile=https://raw.githubusercontent.com/terrapkg/subatomic-repos/main/terra.repo
dnf -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo

# Install akmods, kernel, and modules
dnf -y install \
    kernel-cachyos-lto \
    kernel-cachyos-lto-devel \
    akmods \
    zenergy \
    scx-scheds \
    scx-tools \
    scx-manager
dnf -y swap zram-generator-defaults cachyos-settings

# Manually build modules, run depmod & generate initramfs
VER=$(basename /usr/lib/modules/*)
akmods --force --kernels $VER --kmod zenergy

export DRACUT_NO_XATTR=1
dracut --kver $VER --force --add ostree --no-hostonly --reproducible /usr/lib/modules/$VER/initramfs.img

# Clean up repos
rm -f /etc/yum.repos.d/{*copr*,*terra*,*multimedia*}.repo