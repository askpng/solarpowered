#!/usr/bin/env bash

set -oue pipefail

echo 'Preparing directory for cloning...'

mkdir -p /tmp/clone/Tela/
cd /tmp/clone/Tela/
echo 'Directory created.'

git clone https://github.com/vinceliuice/Tela-icon-theme.git
echo 'Repo cloned. Running install script...'

Tela-icon-theme/install.sh -d /usr/share/icons
echo 'Install script finished. Removing cloned repo...'

rm -r Tela-icon-theme/
echo 'Cloned repo deleted.'