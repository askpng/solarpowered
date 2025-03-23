#!/usr/bin/env bash

set -ouex pipefail

# dnf5 remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra -y

# for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra; do
#     rpm --erase $pkg --nodeps
# done

KERNEL_TAG=6.13.7-108.1
KERNEL_VERSION=6.13.7-108.bazzite.fc41.x86_64

# dnf5 install -y \
#     https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-$KERNEL_VERSION.rpm \
#     https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-core-$KERNEL_VERSION.rpm \
#     https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-$KERNEL_VERSION.rpm \
#     https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-core-$KERNEL_VERSION.rpm \
#     https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-extra-$KERNEL_VERSION.rpm \
#     https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-uki-virt-$KERNEL_VERSION.rpm # \
    # https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-devel-$KERNEL_VERSION.rpm \
    # https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-devel-matched-$KERNEL_VERSION.rpm \

dnf swap -y \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-$KERNEL_VERSION.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-$KERNEL_VERSION.rpm \
    kernel-modules-core https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-core-$KERNEL_VERSION.rpm \
    kernel-core https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-core-$KERNEL_VERSION.rpm \
    kernel-modules-extra https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-extra-$KERNEL_VERSION.rpm



# dnf swap kernel -y https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-$KERNEL_VERSION.rpm

# dnf swap -y kernel-modules https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-$KERNEL_VERSION.rpm

# dnf swap -y kernel-modules-core https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-core-$KERNEL_VERSION.rpm

# dnf swap -y kernel-core https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-core-$KERNEL_VERSION.rpm
