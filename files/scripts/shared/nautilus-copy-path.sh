#!/usr/bin/env bash

set -oue pipefail

echo 'Preparing directory for cloning...'

mkdir -p /tmp/clone/nautilus-copy-path/
cd /tmp/clone/nautilus-copy-path/
echo 'Directory created.'

git clone https://github.com/chr314/nautilus-copy-path.git
echo 'Repo cloned. Copying files...'

mkdir -p /usr/share/nautilus-python/extensions/nautilus-copy-path
cp ./nautilus-copy-path/nautilus-copy-path.py /usr/share/nautilus-python/extensions
cp ./nautilus-copy-path/nautilus_copy_path.py ./nautilus-copy-path/translation.py ./nautilus-copy-path/config.json /usr/share/nautilus-python/extensions/nautilus-copy-path
cp -rf ./nautilus-copy-path/translations /usr/share/nautilus-python/extensions/nautilus-copy-path

echo 'Install script finished. Removing cloned repo...'

rm -r nautilus-copy-path
echo 'Cloned repo deleted.'