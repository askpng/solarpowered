#!/usr/bin/env bash

set -oue pipefail

echo 'Preparing directory for cloning...'

mkdir -p /tmp/clone/MoreWaita/
cd /tmp/clone/WoreWaita/
echo 'Directory created.'

git clone https://github.com/somepaulo/MoreWaita.git
echo 'Repo cloned. Running install script...'

MoreWaita/install.sh
echo 'Install script finished. Removing cloned repo...'

rm -r MoreWaita
echo 'Cloned repo deleted.'