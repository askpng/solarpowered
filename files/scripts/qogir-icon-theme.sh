#!/usr/bin/env bash

set -oue pipefail

echo 'Preparing directory for cloning...'

mkdir -p /tmp/clone/Qogir/
cd /tmp/clone/Qogir/
echo 'Directory created.'

git clone https://github.com/vinceliuice/Qogir-icon-theme.git
echo 'Repo cloned. Running install script...'

Qogir-icon-theme/install.sh -d /usr/share/icons
echo 'Install script finished. Removing cloned repo...'

rm -r Qogir-icon-theme/
echo 'Cloned repo deleted.'