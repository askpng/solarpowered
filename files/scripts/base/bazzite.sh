#!/usr/bin/env bash

set -ouex pipefail

OS_VERSION=$(rpm -E %fedora)

SEARCH_STRING=".fc${OS_VERSION}.x86_64.rpm"

KERNEL_TAG=$(curl -s "https://api.github.com/repos/bazzite-org/kernel-bazzite/releases" | \
             jq -r --arg search_str "$SEARCH_STRING" \
             '.[] | select(.assets[] | .name | endswith($search_str)) | .tag_name' | \
             sort -V | tail -n 1)

if [[ -z "$KERNEL_TAG" ]]; then
    echo "Error: No release with assets matching '$SEARCH_STRING'"
    exit 1
fi

echo "Found matching kernel tag: $KERNEL_TAG"


dnf -y remove kernel-* && rm -drf /usr/lib/modules/*

echo 'Installing Bazzite kernel...'
dnf install -y \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-common-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-core-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-devel-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-devel-matched-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-akmods-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-core-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-extra-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-extra-matched-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-modules-internal-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-tools-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$KERNEL_TAG/kernel-tools-libs-$KERNEL_TAG.fc$OS_VERSION.x86_64.rpm