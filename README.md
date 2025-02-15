# <center>☀️ solarpowered ☀️</center>

solarpowered is a learning and hobby project. My main goal is to better understand OCI images as a concept and in practice, and to eventually end up with the ideal base image for my laptop and future devices.

These images boot and are fully functional for daily operations - further than that, I do not guarantee anything. I also deploy experiments every so often, and breakages or mishaps may happen. If you choose to daily-drive any of my images, kindly notify me so I know when to hold back.


## Why did you name this 'solarpowered'?
Because I like Gawain from Fate/Extra & Fate/Grand Order.

# Image details
- [BlueBuild Template](https://github.com/blue-build/template) with actions set up. WIthout BlueBuild, I would never have come up with the idea of exploring OCI images.
- [silverblue-main](https://github.com/ublue-os/main/pkgs/container/silverblue-main) as base image for solarpowered and solarpowered-ex. Only the latest Fedora relase is supported. Release versions will be bumped 1-2 months after it is made available for public.

## Build status
<center>

|  	| solarpowered 	| solarpowered-ex 	| autosolarpowered 	| autosolarpowered-ex 	| solarizzed 	|
|---	|---	|---	|---	|---	|---	|
| description 	| Silverblue image based on UBlue's `silverblue-main`, built for Lenovo T480/s devices 	| Silverblue image based on UBlue's  `silverblue-main`, built for AMD devices in mind 	| Silverblue image based on vanilla Silverblue, built for Lenovo T480/s devices 	| Silverblue image based on vanilla Silverblue, built for AMD devices in mind 	| `bazzite-deck` layered with theming packages, Codium & Windscribe VPN 	|
| build status 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build.yml) 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build.yml) 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build-autosolarpowered.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-autosolarpowered.yml) 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build-autosolarpowered.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-autosolarpowered.yml) 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build-solarizzed.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-solarizzed.yml) 	|
| functional status 	| Fully functional for DD 	| Fully functional for DD 	| Fully functional for DD 	| Fully functional for DD 	| Fully functional for DD 	|
| build schedule 	| 17:30 UTC Mondays & Fridays 	| 17:30 UTC Mondays & Fridays 	| 18:00 UTC Mondays & Fridays 	| 18:00 UTC Mondays & Fridays 	| 06:00 UTC Mondays 	|

</center>

# Highlights

- Multimedia codecs, `intel-vaapi-driver` & MESA packages from RPMFusion & `fedora-multimedia`
- `bootc`, `codium`, `distrobox`, `topgrade` installed natively
- CLI utilities installed natively, such as `fastfetch`, `fish`, `just`, and `wl-clipboard`
- GNOME Boxes for virtualization installed natively
- [mutter-patched](https://copr.fedorainfracloud.org/coprs/trixieua/mutter-patched/) installed
- `nautilus-extensions` and `nautilus-python` installed - also comes with [nautilus-copy-path](https://github.com/chr314/nautilus-copy-path) installed
- `adw-gtk3-theme`, Fonts Tweak TZool, Waydroid, Windscribe, and Zen Browser (sneexy) installed natively
- Natively installed Fedora bookmarks, background, extensions, repos, and Flathub remote removed
- Natively installed GNOME extensions removed
- Natively installed Firefox removed

## auto/solarpowered

Uses [kernel-blu](https://copr.fedorainfracloud.org/coprs/sentry/kernel-blu/).

Includes the following tools for maximum Lenovo T480/s functionality with 0 layering:
- `igt-gpu-tools` for monitoring iGPU use
- [python/validity](https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/) (sneexy)
- [throttled](https://copr.fedorainfracloud.org/coprs/abn/throttled/) (abn)
- TLP
- `zcfan`

It is recommended to run `append solarpowered-setup` upon installation. This installs TLP-UI Flatpak, configrues necessary kernel arguments & local `initramfs` regeneration, and enables `python-validity` and `zcfan`. It is recommended to reboot afterwards. 

> NOTE: This does *not* configure `throttled`, as undervolt stable values differ between machines.

## solarizzed

README under construction

## auto/solarpowered-ex

Uses [kernel-cachyos](https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/).

Includes the following tools:
- [LACT-libadwaita](https://copr.fedorainfracloud.org/coprs/ilyaz/LACT/)
- `nvtop`

It is recommended to run `append solarpowered-ex-setup` upon installation. This enables the B550 suspend fix systemd service, configures necessary kernel arguments & local `initramfs` regeneration, and enables GNOME Variable Refresh Rate. It is recommended to reboot afterwards. 

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

### autosolarpowered
1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/autosolarpowered:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/autosolarpowered:latest --reboot
  ```

### autosolarpowered-ex
1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/autosolarpowered-ex:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/autosolarpowered-ex:latest --reboot

### solarizzed
1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarizzed:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarizzed:latest --reboot
  ```


## ISO
An ISO file for a fresh install can be generated using `docker` or `podman` from a Silverblue system.

### Docker: solarpowered
```
mkdir ./iso-output
sudo docker run --rm --privileged --volume ./iso-output:/build-container-installer/build --pull=always \
ghcr.io/jasonn3/build-container-installer:latest \
IMAGE_REPO=ghcr.io/askpng \
IMAGE_NAME=solarpowered \
IMAGE_TAG=latest \
VARIANT=Silverblue
```
### Docker: solarpowered-ex
```
mkdir ./iso-output
sudo docker run --rm --privileged --volume ./iso-output:/build-container-installer/build --pull=always \
ghcr.io/jasonn3/build-container-installer:latest \
IMAGE_REPO=ghcr.io/askpng \
IMAGE_NAME=solarpowered-ex \
IMAGE_TAG=latest \
VARIANT=Silverblue
```

### Podman: solarpowered
```
mkdir ./iso-output
sudo podman run --rm --privileged --volume ./iso-output:/build-container-installer/build --security-opt label=disable --pull=newer \
ghcr.io/jasonn3/build-container-installer:latest \
IMAGE_REPO=ghcr.io/askpng \
IMAGE_NAME=solarpowered \
IMAGE_TAG=latest \
VARIANT=Silverblue
```
### Podman: solarpowered-ex
```
mkdir ./iso-output
sudo podman run --rm --privileged --volume ./iso-output:/build-container-installer/build --security-opt label=disable --pull=newer \
ghcr.io/jasonn3/build-container-installer:latest \
IMAGE_REPO=ghcr.io/askpng \
IMAGE_NAME=solarpowered-ex \
IMAGE_TAG=latest \
VARIANT=Silverblue
```

## Verification
These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign).

### Verify `cosign.pub`

Download the `cosign.pub` file from this repo and run the following command within the same directory:

```bash
cosign verify --key cosign.pub ghcr.io/askpng/solarpowered
```
