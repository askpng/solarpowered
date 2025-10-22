#!/usr/bin/env bash

set -ouex pipefail

GIT=https://github.com/bazzite-org/kernel-bazzite
GITOWNER=$(echo "$GIT" | sed -E 's#https://github.com/([^/]+)/([^/]+)(\.git)*#\1#')
GITREPO=$(echo "$GIT" | sed -E 's#https://github.com/([^/]+)/([^/]+)(\.git)*#\2#')

OS_VERSION=$(rpm -E %fedora)
FC_SEARCH_STRING=".bazzite.fc${OS_VERSION}."
KERNEL_TAG=$(curl -s "https://api.github.com/repos/$GITOWNER/$GITREPO/releases" | \
             jq -r --arg search_str "$FC_SEARCH_STRING" \
             '.[] | select(.assets[] | .name | contains($search_str)) | .tag_name' | \
             head -n 1)

if [[ -z "$KERNEL_TAG" ]]; then
    echo "Error: No release with assets matching '$FC_SEARCH_STRING'"
    exit 1
fi

echo "Found matching kernel tag: $KERNEL_TAG"
KERNEL_VERSION=$KERNEL_TAG

echo 'Installing Bazzite kernel...'
dnf5 install -y \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-core-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-modules-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-modules-core-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-modules-extra-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-modules-extra-matched-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-devel-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm \
    https://github.com/$GITOWNER/$GITREPO/releases/download/$KERNEL_TAG/kernel-devel-matched-$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64.rpm

echo 'Downloading ublue-os akmods COPR repo file'
curl -L https://copr.fedorainfracloud.org/coprs/ublue-os/akmods/repo/fedora-$(rpm -E %fedora)/ublue-os-akmods-fedora-$(rpm -E %fedora).repo -o /etc/yum.repos.d/_copr_ublue-os-akmods.repo

echo 'Installing zenergy kmod'
dnf5 install -y \
    akmod-zenergy-*.fc$OS_VERSION.x86_64

akmods --force --kernels $KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64 --kmod zenergy
modinfo /usr/lib/modules/$KERNEL_VERSION.bazzite.fc$OS_VERSION.x86_64/extra/zenergy/zenergy.ko.xz > /dev/null \
    || (find /var/cache/akmods/zenergy/ -name \*.log -print -exec cat {} \; && exit 1)

echo 'Removing ublue-os akmods COPR repo file'
rm /etc/yum.repos.d/_copr_ublue-os-akmods.repo