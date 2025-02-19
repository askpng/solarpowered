#!/usr/bin/env bash

set -oue pipefail

GITHUB_URL="https://github.com/vinceliuice/Tela-icon-theme"
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

if [ -f "./$REPO_NAME/install.sh" ]; then
  chmod +x "./$REPO_NAME/install.sh"
  ./"$REPO_NAME/install.sh" -d /usr/share/icons
fi

echo "Folders copied. Cleaning up!"
rm -drf "$CLONE_DIR"
echo "Cloned repo deleted."

echo "Script finished. Theme installation complete."
