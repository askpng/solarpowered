#!/usr/bin/env bash

set -oue pipefail

echo 'Preparing directory for cloning...'

mkdir -p /tmp/clone/
cd /tmp/clone/
echo 'Directory created.'

git clone https://github.com/Notify-ctrl/Plasma-Overdose.git
echo 'Repo cloned. Copying files...'

# theme
cp -r ./Plasma-Overdose/aurorae /usr/share/aurorae/themes/
# cursors
cp -r ./Plasma-Overdose/cursors /usr/share/icons/CursorsOverdose/
# colorscheme
cp -r ./Plasma-Overdose/colorschemes /usr/share/color-schemes/
# global theme
cp -r ./Plasma-Overdose/plasma /usr/share/
echo 'Folders copied. Cleaning up!'

rm -drf Plasma-Overdose/
echo 'Cloned repo deleted.'
