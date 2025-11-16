#!/usr/bin/env bash

set -ouex pipefail

OS_VERSION=$(rpm -E %fedora)

VER=$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/bazzite-org/kernel-bazzite/releases/latest))

dnf -y remove kernel-* && rm -drf /usr/lib/modules/*

echo 'Installing Bazzite kernel...'
dnf install -y \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-common-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-core-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-devel-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-devel-matched-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-akmods-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-core-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-extra-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-extra-matched-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-internal-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-tools-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-tools-libs-$VER.fc$OS_VERSION.x86_64.rpm