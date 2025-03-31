#!/usr/bin/env bash

set -ouex pipefail

GIT=https://github.com/bazzite-org/kernel-bazzite
GITOWNER=$(echo "$GIT" | sed -E 's#https://github.com/([^/]+)/([^/]+)(\.git)*#\1#')
GITREPO=$(echo "$GIT" | sed -E 's#https://github.com/([^/]+)/([^/]+)(\.git)*#\2#')

KERNEL_TAG=$(curl https://api.github.com/repos/$GITOWNER/$GITREPO/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")
KERNEL_VERSION=$KERNEL_TAG
OS_VERSION=42

echo 'Installing Bazzite kernel.'
dnf5 install -y \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-core-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-modules-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-modules-core-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-modules-extra-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-uki-virt-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm # \
    #c https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-devel-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    # https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-devel-matched-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
