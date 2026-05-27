#!/usr/bin/env bash

dnf -y install dnf-plugins-core --setopt=install_weak_deps=False

dnf -y config-manager setopt fastestmirror=1
dnf -y config-manager setopt install_weak_deps=False

# Exclude Fedora mainline kernel
dnf -y config-manager setopt "fedora*".exclude=" \
    kernel \
    kernel-devel \
    kernel-headers \
    kernel-core* \
    kernel-debug* \
    kernel-devel* \
    kernel-modules* \
    kernel-tools* \
    "
dnf -y config-manager setopt "updates*".exclude=" \
    kernel \
    kernel-devel \
    kernel-headers \
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
dnf -y copr enable sentry/kernel-blu
dnf -y config-manager addrepo --from-repofile=https://raw.githubusercontent.com/terrapkg/subatomic-repos/main/terra.repo
dnf -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo

# Install akmods, kernel, and modules
dnf -y install \
    kernel \
    kernel-devel \
    kernel-modules-extra \
    akmods \
    help2man \
    v4l2loopback \
    zenergy

# Manually build modules, run depmod & generate initramfs
VER=$(basename /usr/lib/modules/*)
akmods --force --kernels $VER --kmod v4l2loopback
akmods --force --kernels $VER --kmod zenergy

export DRACUT_NO_XATTR=1
dracut --kver $VER --force --add ostree --no-hostonly --reproducible /usr/lib/modules/$VER/initramfs.img

# Clean up repos
rm -f /etc/yum.repos.d/{*copr*,*terra*,*multimedia*}.repo