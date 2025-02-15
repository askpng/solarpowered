#!/usr/bin/env bash

set -oue pipefail

echo 'Preparing directory for cloning...'

mkdir -p /tmp/clone/Adwaita-colors/
cd /tmp/clone/Adwaita-colors/
echo 'Directory created.'

git clone https://github.com/dpejoh/Adwaita-colors
echo 'Repo cloned. Copying files...'

cp -r ./Adwaita-colors/* /usr/share/icons/
echo 'Folders copied. Cleaning up!'

rm -r Adwaita-colors/
echo 'Cloned repo deleted.'
