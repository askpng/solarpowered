# <center>☀️ solarpowered ☀️</center>

solarpowered is a learning and hobby project. My main goal is to better understand OCI images as a concept and in practice, and to eventually end up with the ideal base image for my laptop and future devices.

These images boot and are fully functional for daily operations - further than that, I do not guarantee anything.

## Why did you name this 'solarpowered'?
Because I like Gawain from Fate/Extra & Fate/Grand Order.

# Image details
- [BlueBuild Template](https://github.com/blue-build/template) with actions set up. WIthout BlueBuild, I would never have come up with the idea of exploring OCI images.
- [silverblue-main](https://github.com/ublue-os/main/pkgs/container/silverblue-main) as base image for solarpowered and solarpowered-ex. Only the latest Fedora relase is supported. Release versions will be bumped 1-2 months after it is made available for public.

## Build status
<center>

|  	| solarpowered-raw 	| solarpowered 	| solarpowered-ex 	| solarizzed 	|
|---	|---	|---	|---	|---	|
| **Description** 	| Base image built upon vanilla Silverblue 	| Optimized for Lenovo T480/s devices 	| Optimized for desktop PCs with AMD internals 	| Image based on `bazzite-deck` with added desktop prettifiers and VPN 	|
| **Build status** 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build-raw.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-raw.yml) 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build.yml) 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-ex.yml) 	| [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build-solarizzed.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-solarizzed.yml) 	|
| **Functional status** 	| Fully functional & DD 	| Fully functional & DD 	| Fully functional & DD 	| Fully functional & DD 	|
| **Build schedule** 	| Mondays & Fridays, 17:00 UTC 	| Thursdays, 17:30 UTC 	| Mondays & Thursdays, 17:30 UTC 	| Mondays, 6:00 UTC 	|

</center>

## solarpowered

This image supports Lenovo T480(s) and contains:

- [blu kernel](https://copr.fedorainfracloud.org/coprs/sentry/kernel-blu/)
- `igt-gpu-tools`
- `python-validity` forked by [sneexy](https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/)
- `tlp` and `tlp-rdw`
> `tlp.service` is enabled by default with TLP default configs. `systemd-rfkill.{service,socket}` is disabled by default.
- `throttled`
> `throttled` is shipped with the [defaults](https://github.com/erpalma/throttled/blob/master/etc/throttled.conf) but slightly different configuration structure. I use universal values for AC and battery so there is no `[UNDERVOLT.AC]` nor `[UNDERVOLT.BATTERY]`, only `[UNDERVOLT]`. Documented in the `throttled` [README](https://github.com/erpalma/throttled#undervolt).
- `zcfan`

The following packages are explicitly removed from the base image due to conflicts.
- `fprintd`
- `fprintd-pam`
- `tuned` and `tuned-ppd`
- `thermald`

## solarpowered-ex
This configuration is intended to support my desktop configuration. Changes to this image is frequent.

<details>
  <summary>Desktop configuration details</summary>
  
  | Type | Model|
  | --- | --- |
  | Motherboard | ASRock B550M WiFi SE |
  | CPU | AMD Ryzen 5 5600 |
  | GPU | Sapphire AMD Navi 23 Radeon RX 6600 |
  | Wireless adapter | Intel Dual Band Wireless-AC 3168NGW |
  | Bluetooth adapter | Intel Wireless-AC 3168 Bluetooth |
  | Storage | [Solidigm P41 Plus 1 TB](https://www.solidigm.com/products/client/plus-series/p41.html) |
  | Controller | [Fantech Nova PRO WGP14V2](https://fantechworld.com/products/nova-pro-wgp14v2) recognized as `Sony DualShock 4 [CUH-ZCT2x]` |
  | Webcam/Mic | 0c45:636b Microdia Lumi Cam |

</details>

This image contains:

- [cachy kernel](https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/)
- `lact-libadwaita` from [ilya-zlobintsev](https://github.com/ilya-zlobintsev/LACT)
- `nvtop `

### B550 suspend fix

This image includes the fix to [B550 boards suspend issue](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#PC_will_not_wake_from_sleep_on_A520I_and_B550I_motherboards). Enable the fix with the following command:

```sudo systemctl enable --now b550-suspend-fix.service```

### solarizzed

This image contains the following minor additions:

- VSCodium installed natively
- Windscribe VPN client
- Fonts
- Multiple sound themes (Deepin, Oxygen, Pop!, and Yaru)
- Multiple icon sets (Tela and Qogir) and themes (ChromeOS, Layan, Plasma-Overdose)

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
