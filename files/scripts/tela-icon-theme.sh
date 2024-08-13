#!/usr/bin/env bash

set -oue pipefail

echo 'Prepare directory for cloning...'

mkdir /tmp/clone/
cd /tmp/clone/
echo 'Directory created. Cloning git repo...'

git clone https://github.com/vinceliuice/Tela-icon-theme.git
echo 'Repo cloned. Running install script...'

Tela-icon-theme/install.sh -d /usr/share/icons
echo 'Install script finished. Removing cloned repo...'

rm -r Tela-icon-theme/
echo 'Cloned repo deleted.'