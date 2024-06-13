#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

### EXAMPLE STARTS HERE ###

# Your code goes here.
echo 'Enable SElinux policy'
setsebool -P domain_kernel_load_modules on

echo 'CachyOS kernel override'
rpm-ostree cliwrap install-to-root / && \
rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install kernel-cachyos-lts

echo 'Exclude official kernel from updates'
sed -i '/^\[updates\]/a\exclude\=kernel\*' /etc/yum.repos.d/fedora-updates.repo

echo 'Install uksmd'
rpm-ostree install libcap-ng-devel procps-ng-devel uksmd-lts
systemctl enable uksmd.service

### source: https://github.com/deus0ne/beret/blob/main/config/scripts/cachyos-kernel-override.sh ###