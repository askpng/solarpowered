# <center>☀️ solarpowered ☀️</center>

`solarpowered` and `solarpowered-ex` are custom images based on [Fedora Silverblue](https://quay.io/repository/fedora/fedora-silverblue?tab=tags) using [BlueBuild](https://github.com/blue-build/template). I started this project as a learning and hobby project to familiarize myself with containers, Linux, and GitHub. 

Both images are fully functional for daily operations.

Also check out [atomic-t480s](https://github.com/askpng/atomic-t480s), much simpler custom image project I started to support Lenovo Thinkpad T480s users.

I named this project `solarpowered` because I like Gawain from Fate/Extra & Fate/Grand Order.

# Highlights

- Multimedia codecs from `fedora-multimedia` repo (and `intel-media-driver` from RPM Fusion)
- Distrobox, Just, and VSCodium
- Waydroid and ADB
- Nautilus addons
- More vanilla GNOME Experience
- Zen Browser instead of Firefox
- Colloid, MoreWaita, Tela, and Qogir icon themes
- Nerd Fonts Symbols and a small selection of fonts from Google Fonts 
- Several sound & icon themes & fonts installed OOTB

## solarpowered - made to support Lenovo T480/s devices

Includes the following tools for maximum Lenovo T480/s functionality with 0 layering:
- `igt-gpu-tools` for monitoring iGPU use
- [python-validity](https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/) (sneexy)
- [throttled](https://copr.fedorainfracloud.org/coprs/abn/throttled/) (abn)
- TLP
- `zcfan`

This image is shipped with [kernel-blu](https://copr.fedorainfracloud.org/coprs/sentry/kernel-blu/) with `v4l2loopback` kernel module

It is highly recommended to run `append solarpowered-setup` upon installation. This installs TLP-UI Flatpak, configrues necessary kernel arguments & local `initramfs` regeneration, and enables `python-validity` and `zcfan`. It is recommended to reboot afterwards. 

> NOTE: This does *not* configure `throttled`, as undervolt stable values differ between machines. For further information about undervolting, refer to the official documentation on `throttled`.

## solarpowered-ex - for Ryzen/AMD computers

Includes the following tools:
- Gamescope, Lutris, MangoHud and experimental implementation of Steam Gaming Mode
- Beta/Unstable version of Sunshine for game streaming
- Ramalama and ROCM packages
- [LACT-libadwaita](https://copr.fedorainfracloud.org/coprs/ilyaz/LACT/)

This image is shipped with [kernel-cachyos-lto](https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/) with its built-in `v4l2loopback`, `evdi` and `displaylink`, as well as `zenergy` for Ryzen power stats reading.

# Installation

You can install by rebasing from Silverblue or generating an ISO file yourself. If you decide to give this a go, and would like to provide feedback and/or suggestions, feel free to open a new issue.

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

## Verification
These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign).

### Verify `cosign.pub`

Download the `cosign.pub` file from this repo and run the following command within the same directory:

```bash
cosign verify --key cosign.pub ghcr.io/askpng/solarpowered
```
