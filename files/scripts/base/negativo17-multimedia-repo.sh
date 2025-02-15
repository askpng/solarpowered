#!/usr/bin/env bash
set -euo pipefail

# Install negativo17-multimedia-repo
echo 'Installing negativo17-multimedia-repo'
curl -fLs --create-dirs https://negativo17.org/repos/fedora-multimedia.repo -o /etc/yum.repos.d/negativo17-fedora-multimedia.repo
sed -i '0,/enabled=1/{s/enabled=1/enabled=1\npriority=90/}' /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# Replace multimedia packages with ones from negativo17-multimedia-repo
echo 'Replacing multimedia packages to packages from negativo17-multimedia-repo'
rpm-ostree override replace --experimental --from repo='fedora-multimedia' \
    libheif \
    libva \
    libva-intel-media-driver \
    mesa-dri-drivers \
    mesa-filesystem \
    mesa-libEGL \
    mesa-libGL \
    mesa-libgbm \
    mesa-libglapi \
    mesa-libxatracker \
    mesa-va-drivers \
    mesa-vulkan-drivers

# Remove negativo17-multimedia-repo
# echo 'Removing negativo17-multimedia-repo'
# rm -f /etc/yum.repos.d/negativo17-fedora-multimedia.repo

rpm-ostree override replace --from repo='fedora' --experimental --remove=OpenCL-ICD-Loader ocl-icd || true