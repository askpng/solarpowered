# <center>☀️ solarpowered ☀️</center>

solarpowered is a learning and hobby project. My main goal is to better understand OCI images as a concept and in practice, and to eventually end up with the ideal base image for my laptop and future devices.

These images boot and are fully functional for daily operations - further than that, I do not guarantee anything. I also deploy experiments every so often, and breakages or mishaps may happen. If you choose to daily-drive any of my images, kindly notify me so I know when to hold back.


## Why did you name this 'solarpowered'?
Because I like Gawain from Fate/Extra & Fate/Grand Order.

# Image details
- Built using [Bluebuild template](https://github.com/blue-build/template).

# All images

# Highlights

- Multimedia codecs from `fedora-multimedia`
- `bootc`, `codium`, `distrobox`, `topgrade` installed natively
- `fastfetch`, `fish`, `just`, and `wl-clipboard` installed natively
- GNOME Boxes for virtualization installed natively
- [mutter-patched](https://copr.fedorainfracloud.org/coprs/trixieua/mutter-patched/) installed
- `nautilus-extensions` and `nautilus-python` installed - also comes with [nautilus-copy-path](https://github.com/chr314/nautilus-copy-path) installed
- `adw-gtk3-theme`, Fonts Tweak Tool, Waydroid, Windscribe, and Zen Browser installed natively
- Native installs of Fedora bookmarks, background, extensions, repos, and Flathub remote removed
- Native installs of GNOME extensions removed
- Native installs of Firefox removed

## solarpowered - the original, made to support Lenovo T480/s

Uses [kernel-blu](https://copr.fedorainfracloud.org/coprs/sentry/kernel-blu/).

Includes the following tools for maximum Lenovo T480/s functionality with 0 layering:
- `igt-gpu-tools` for monitoring iGPU use
- [python-validity](https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/) (sneexy)
- [throttled](https://copr.fedorainfracloud.org/coprs/abn/throttled/) (abn)
- TLP
- `zcfan`

It is recommended to run `append solarpowered-setup` upon installation. This installs TLP-UI Flatpak, configrues necessary kernel arguments & local `initramfs` regeneration, and enables `python-validity` and `zcfan`. It is recommended to reboot afterwards. 

> NOTE: This does *not* configure `throttled`, as undervolt stable values differ between machines.

## solarpowered-ex - desktop image with LACT installed

Uses [kernel-cachyos](https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/).

Includes the following tools:
- [LACT-libadwaita](https://copr.fedorainfracloud.org/coprs/ilyaz/LACT/)
- `nvtop`

It is recommended to run `append solarpowered-ex-setup` upon installation. This enables the B550 suspend fix systemd service, configures necessary kernel arguments & local `initramfs` regeneration, and enables GNOME Variable Refresh Rate. It is recommended to reboot afterwards. 

## solarizzed-gnome - bazzite-deck-gnome with some pretties and 

README under construction

# Installation

You can install by rebasing from Silverblue or generating an ISO file yourself. If you decide to give this a go, and would like to provide feedback and/or suggestions, feel free to open a new issue!

## Rebase
To rebase from a Silverblue installation, follow the steps below.

### solarpowered

1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarpowered:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarpowered:latest --reboot
  ```

### solarpowered-ex

1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarpowered-ex:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarpowered-ex:latest --reboot
  ```

### solarizzed

1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarizzed-gnome:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarizzed-gnome:latest --reboot
  ```

## Verification
These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign).

### Verify `cosign.pub`

Download the `cosign.pub` file from this repo and run the following command within the same directory:

```bash
cosign verify --key cosign.pub ghcr.io/askpng/solarpowered
```
