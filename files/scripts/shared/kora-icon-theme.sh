#!/usr/bin/env bash

set -oue pipefail

GITHUB_URL="https://github.com/bikass/kora"

if [ -z "$GITHUB_URL" ]; then
  echo "Error: GITHUB_URL is not set."
  exit 1
fi

REPO_NAME=$(basename "$GITHUB_URL" .git)
CLONE_DIR="/tmp/clone/$REPO_NAME"

echo "Preparing directory for cloning..."
mkdir -p "$CLONE_DIR"
cd "$CLONE_DIR"
echo "Directory created."

git clone "$GITHUB_URL"

echo "Repo cloned. Copying files..."

if [ -d "./$REPO_NAME/kora" ]; then
  echo "Installing kora icon set..."
  cp -r "./$REPO_NAME/kora" /usr/share/icons/
fi
if [ -d "./$REPO_NAME/kora-light" ]; then
  echo "Installing kora-light icon set..."
  cp -r "./$REPO_NAME/kora-light" /usr/share/icons/
fi
if [ -d "./$REPO_NAME/kora-light-panel" ]; then
  echo "Installing kora-light-panel icon set..."
  cp -r "./$REPO_NAME/kora-light-panel" /usr/share/icons/
fi
if [ -d "./$REPO_NAME/kora-pgrey" ]; then
  echo "Installing kora-pgrey icon set..."
  cp -r "./$REPO_NAME/kora-pgrey" /usr/share/icons/
fi

echo "Folders copied. Cleaning up!"
rm -drf "$CLONE_DIR"
echo "Cloned repo deleted."

echo "Script finished. Theme installation complete."