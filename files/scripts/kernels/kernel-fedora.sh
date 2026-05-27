#!/usr/bin/env bash

# Install dnf-plugins-core just in case
dnf -y install --setopt=install_weak_deps=False \
    dnf-plugins-core
    
dnf -y config-manager setopt fastestmirror=1
dnf -y config-manager setopt install_weak_deps=False

# Enable repos for akmods
dnf -y config-manager addrepo --from-repofile=https://raw.githubusercontent.com/terrapkg/subatomic-repos/main/terra.repo

# Install akmods, kernel, and modules
dnf -y install --setopt=install_weak_deps=False \
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

# Clean up repos from earlier
rm -f /etc/yum.repos.d/{*copr*,*terra*}.repo