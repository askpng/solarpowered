#!/usr/bin/env bash

set -oue pipefail

echo 'Preparing directory for cloning...'

mkdir -p /tmp/clone
cd /tmp/clone/
echo 'Directory created.'

git clone https://github.com/vinceliuice/Layan-kde.git
echo 'Repo cloned. Running install script...'

Layan-kde/install.sh
echo 'Install script finished. Removing cloned repo...'

rm -r Layan-kde
echo 'Cloned repo deleted.'