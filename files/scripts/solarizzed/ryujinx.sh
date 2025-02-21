#!/usr/bin/env bash

set -euo pipefail

GIT=https://github.com/Ryubing/Ryujinx    
APPDIR=/usr/libexec/appimages
GITOWNER=$(echo "$GIT" | sed -E 's#https://github.com/([^/]+)/([^/]+)(\.git)*#\1#')
GITREPO=$(echo "$GIT" | sed -E 's#https://github.com/([^/]+)/([^/]+)(\.git)*#\2#')
APPNAME=$GITREPO

echo 'Downloading latest version of $APPNAME from $GITOWNER/$GITREPO'.

URL="https://github.com/$GITOWNER/$GITREPO/releases/download/$(curl https://api.github.com/repos/$GITOWNER/$GITREPO/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")/ryujinx-$(curl https://api.github.com/repos/$GITOWNER/$GITREPO/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")-x64.AppImage"

echo "Downloading $URL as $APPDIR/$APPNAME.AppImage"

mkdir -p $APPDIR

curl -L "$URL" -o "$APPDIR/$APPNAME.AppImage"

echo "Download finished! Making $APPNAME executable..."
chmod +x $APPDIR/$APPNAME.AppImage

echo "Creating symlink to /usr/bin/$APPNAME..."
ln -sf $APPDIR/$APPNAME.AppImage /usr/bin/$APPNAME

echo "/usr/bin/$APPNAME symlink created!"
