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

| | solarpowered / T480s image | solarpowered-ex / desktop image
| --- | --- | --- |
| **Status** | <center> [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build.yml) </center> | <center> [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build-ex.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-ex.yml) </center> |
| **Description** | This image contains fingerprint drivers and power management tools for Lenovo T480/s. | This image is built to support my AMD computer. Intended for daily use, multimedia, and gaming. |
| **Functional status** | Fully functional | Fully functional |
| **Scheduled build** | 03:00 UTC on Fridays | 03:00 UTC daily |

</center>

## solarpowered for T4809s

This image supports Lenovo T4809(s) and contains:

- `igt-gpu-tools`
- `python-validity` forked by [sneexy](https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/)
- `tlp` and `tlp-rdw`
> `tlp.service` is enabled by default with TLP default configs. `systemd-rfkill.{service,socket}` is disabled by default.
- `throttled`
> `throttled` is shipped with the [defaults](https://github.com/erpalma/throttled/blob/master/etc/throttled.conf) but slightly different configuration structure. I use universal values for AC and battery so there is no `[UNDERVOLT.AC]` nor `[UNDERVOLT.BATTERY]`, only `[UNDERVOLT]`. Documented in the `throttled` [README](https://github.com/erpalma/throttled#undervolt).
- `zcfan`
> Before enabling `zcfan`, run `rpm-ostree kargs --append=thinkpad_acpi.fan_control=1` and reboot for it to work. If you are running a full Intel T480(s), you can also run `ujust t480s-set-kargs` to apply it with other kernel parameters to enable GuC a& FBC and reboot. Then, run `sudo systemctl enable --now zcfan`.

The following packages are explicitly removed from the base image due to conflicts.
- `fprintd`
- `fprintd-pam`
- `power-profiles-daemon`
- `thermald`

## solarpowered-ex: Desktop exclusive packages
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

- `goverlay`
- `inxi`
- `lact` from [ilya-zlobintsev](https://github.com/ilya-zlobintsev/LACT)
- `mangohud`
- `radeontop`
- `system76-scheduler` and `gnome-shell-extension-system76-scheduler` from [kylegospo/system76-scheduler](https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/)

### Kernel

The Fedora default kernel is replaced with the [Fsync kernel](https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/).

> NOTE: Fsync kernel updates have been a bit wonky recently, causing booting failures with the `Linux Kernel panic: VFS: Unable to mount root fs` error message in the boot logs. I am monitoring the behavior at the moment - expect frequent changes to the kernel choice. Might eventually switch to other kernels if the situation does not improve.

### B550 suspend fix

This image includes the fix to [B550 boards suspend issue](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#PC_will_not_wake_from_sleep_on_A520I_and_B550I_motherboards). Enable the fix with the following command:

```sudo systemctl enable --now b550-suspend-fix.service```

## Automatic updates

> Better writeup planned! 

System updates are handled by `rpm-ostreed-automatic.service`. To override the timer settings, create `/etc/systemd/system/rpm-ostreed-automatic.timer.d/override.conf`.

Other updates are handled by `topgrade.service`. Enable with `sudo systemctl enable --now topgrade.{timer,service}.` To override the timer settings, create `/etc/systemd/system/topgrade.timer/override.conf`.

# Installation

You can install by rebasing from Silverblue or generating an ISO file yourself. If you decide to give this a go, and would like to provide feedback and/or suggestions, feel free to open a new issue!

## Rebase
To rebase from a Silverblue installation, follow the steps below.

### T480(s) image
1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarpowered:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarpowered:latest --reboot
  ```

### EX/desktop image
1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarpowered-ex:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarpowered-ex:latest --reboot
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
