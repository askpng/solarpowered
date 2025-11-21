#!/usr/bin/env bash
set -euo pipefail

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

rpm-ostree override replace --from repo='fedora' --experimental --remove=OpenCL-ICD-Loader ocl-icd || true