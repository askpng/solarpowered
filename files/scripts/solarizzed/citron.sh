#!/usr/bin/env bash

set -euo pipefail

GIT=https://github.com/pkgforge-dev/Citron-AppImage 
APPDIR=/usr/libexec/appimages
GITOWNER=$(echo "$GIT" | sed -E 's#https://github.com/([^/]+)/([^/]+)(\.git)*#\1#')
GITREPO=$(echo "$GIT" | sed -E 's#https://github.com/([^/]+)/([^/]+)(\.git)*#\2#')
APPNAME=citron

echo 'Downloading latest version of $APPNAME from $GITOWNER/$GITREPO'.

URL="https://github.com/$GITOWNER/$GITREPO/releases/download/v$(curl https://api.github.com/repos/$GITOWNER/$GITREPO/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")/Citron-v$(curl https://api.github.com/repos/$GITOWNER/$GITREPO/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")-anylinux-x86_64_v3.AppImage"

echo "Downloading $URL as $APPDIR/$APPNAME.AppImage"

mkdir -p $APPDIR

curl -L "$URL" -o "$APPDIR/$APPNAME.AppImage"

echo "Download finished! Making $APPNAME executable..."
chmod +x $APPDIR/$APPNAME.AppImage

echo "Creating symlink to /usr/bin/$APPNAME..."
ln -sf $APPDIR/$APPNAME.AppImage /usr/bin/$APPNAME

echo "/usr/bin/$APPNAME symlink created!"
