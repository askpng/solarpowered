#!/usr/bin/env bash

set -ouex pipefail

KERNEL_TAG=6.13.7-109
KERNEL_VERSION=6.13.7-109
OS_VERSION=41

echo 'Removing Fedora kernel.'
dnf remove -y kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra # kernel-uki-virt

echo 'Installing Bazzite kernel.'
dnf5 install -y \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-core-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-core-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-extra-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-uki-virt-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm # \
    #c https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-devel-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    # https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-devel-matched-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
