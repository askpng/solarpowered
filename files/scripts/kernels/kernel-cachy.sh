#!/usr/bin/env bash

# Remove Fedora kernel & remove leftover files
dnf -y remove kernel* && rm -r -f /usr/lib/modules/*
# Install dnf-plugins-core just in case
dnf -y install --setopt=install_weak_deps=False \
    dnf-plugins-core
# Enable CachyOS kernel repo
dnf -y copr enable bieszczaders/kernel-cachyos-lto
# Install CachyOS LTO kernel & akmods
dnf -y install --setopt=install_weak_deps=False \
    kernel-cachyos-lto \
    akmods
# Enable CachyOS addons repo
dnf -y copr enable bieszczaders/kernel-cachyos-addons
# Install SCX-stuff
dnf -y install --setopt=install_weak_deps=False \
    scx-scheds-git \
    scx-manager
dnf -y swap zram-generator-defaults cachyos-settings    
# Disable repos    
dnf -y copr disable bieszczaders/kernel-cachyos-lto
dnf -y copr disable bieszczaders/kernel-cachyos-addons
