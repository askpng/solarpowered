#!/usr/bin/env bash

# Install dnf-plugins-core just in case
dnf -y install --setopt=install_weak_deps=False \
    dnf-plugins-core \
    dnf5-plugins
# Remove & exclude Fedora kernel & remove leftover files
dnf -y remove \
    kernel \
    kernel-*
rm -rf /usr/lib/modules/*
dnf -y config-manager setopt "fedora*".exclude=" \
    kernel \
    kernel-core \
    kernel-modules \
    kernel-modules-core \
    kernel-modules-extra \
    kernel-devel \
    kernel-headers \
    " 
# Enable repos for kernel-blu and akmods
dnf -y copr enable sentry/kernel-blu
dnf -y copr enable ublue-os/akmods
curl -L "https://raw.githubusercontent.com/terrapkg/subatomic-repos/main/terra.repo" -o /etc/yum.repos.d/terra.repo

# Install akmods, kernel, and modules
dnf -y install --setopt=install_weak_deps=False \
    kernel \
    kernel-devel \
    kernel-modules-extra \
    akmods \
    help2man \
    v4l2loopback \
    zenergy

# Manually build modules, run depmod & generate initramfs
VER=$(ls /lib/modules) &&
    akmods --verbose --force --kernels $VER --kmod v4l2loopback &&
    akmods --verbose --force --kernels $VER --kmod zenergy &&
    depmod -a $VER &&
    dracut --kver $VER --force --add ostree --no-hostonly --reproducible /usr/lib/modules/$VER/initramfs.img

# Clean up repos from earlier
rm -f /etc/yum.repos.d/{*copr*,*terra*}    