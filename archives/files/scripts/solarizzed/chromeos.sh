#!/usr/bin/env bash

set -oue pipefail

echo 'Preparing directory for cloning...'

mkdir -p /tmp/clone/ChromeOS-kde
cd /tmp/clone/ChromeOS-kde
echo 'Directory created.'

git clone https://github.com/vinceliuice/ChromeOS-kde.git
echo 'Repo cloned. Running install script...'

ChromeOS-kde/install.sh
echo 'Install script finished. Removing cloned repo...'

rm -r ChromeOS-kde/
echo 'Cloned repo deleted.'