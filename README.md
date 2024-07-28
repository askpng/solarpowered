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
| **Scheduled build** | 03:00 UTC on Fridays | 03:00 UTC on Fridays |

</center>

## Packages

In addition to the default packages installed in the `silverblue-main` base image, the following packages are installed by default. 

> Change is frequent and the README is not always up-to-date. 

- `butter` by [zhangyuannie](https://github.com/zhangyuannie/butter) for BTRFS snapshots (I don't do BTRFS snapshot restores, but it's still nice to have. Might eventually switch to BTRFS Assistant for the maintenance utilities)
- `blackbox-terminal` as the default terminal
- `epson-inkjet-printer-escpr` and `epson-inkjet-printer-escpr2`
- `fastfetch`
- `fish`
- `firewall-config`
- `gnome-shell-extension-gsconnect` and `nautilus-gsconnect`
- `ibus-mocz`
- `lm_sensors`
- `luminance` by [sidevesh](https://github.com/sidevesh/Luminance)
- `lzip`
- `playerctl`
- `pulseaudio-utils`
- `starship`
- `topgrade`
- `wl-clipboard`
- `waydroid`

The following packages are removed from the base image.
- `firefox` and `firefox-langpacks` - Firefox will be installed as a Flatpak
- `htop`
- `nvtop`
- GNOMies I don't use: `gnome-software-rpm-ostree`, `gnome-tour`, `gnome-terminal`, `gnome-terminal-nautilus`, and `yelp`
- GNOME Classic: `gnome-classic-session`, `gnome-classic-session-xsession`
- Default GNOME Extensions: Apps Menu, Background Logo, Launch new instance, Places Menu, and Windows List

### Icons
These icon themes are installed.

- [Morewaita](https://github.com/somepaulo/MoreWaita)

### Fonts
These fonts are installed via the `fonts` module.

- Inter
- Kosugi Maru
- Nerd Fonts Symbols Only
- Ruda
- Ubuntu Mono
- Victor Mono

### solarpowered: T480/s exclusive packages
The following packages are installed by default for improving Lenovo T480/s power management, performance, and features:
- `igt-gpu-tools`
- `python-validity` forked by [sneexy](https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/)
- `tlp` and `tlp-rdw`
- `throttled`
> `throttled` is shipped with [default values](https://github.com/erpalma/throttled/blob/master/etc/throttled.conf) but slightly different defaults. I use universal values for AC and battery so there is no `[UNDERVOLT.AC]` nor `[UNDERVOLT.BATTERY]`, only `[UNDERVOLT]`. Documented in the `throttled` [README](https://github.com/erpalma/throttled#undervolt).
- `zcfan`
> `zcfan` needs `rpm-ostree kargs --append=thinkpad_acpi.fan_control=1` to work. You can also run `ujust set-kargs` to apply it with other kernel parameters.

The following packages are explicitly removed from the base image due to conflicts.
- `fprintd`
- `fprintd-pam`
- `power-profiles-daemon`
- `thermald`

`tlp.service` is enabled by default with TLP defaults. `systemd-rfkill.{service,socket}` is disabled by default.

### solarpowered-ex: Desktop exclusive packages
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

#### Packages

- `goverlay`
- `inxi`
- `lact` from [ilya-zlobintsev](https://github.com/ilya-zlobintsev/LACT)
- `mangohud`
- `radeontop`
- `system76-scheduler` and `gnome-shell-extension-system76-scheduler` from [kylegospo/system76-scheduler](https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/)

#### Kernel

The Fedora default kernel is replaced with the [Fsync kernel](https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/).

#### B550 suspend fix

This image includes the fix to [B550 boards suspend issue](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#PC_will_not_wake_from_sleep_on_A520I_and_B550I_motherboards). Enable the fix with the following command:

```sudo systemctl enable --now b550-suspend-fix.service```

## Automatic updates

> Better writeup planned! 

System updates are handled by `rpm-ostreed-automatic.service`. To override the timer settings, create `/etc/systemd/system/rpm-ostreed-automatic.timer.d/override.conf`.

Other updates are handled by `topgrade.service`. Enable with `sudo systemctl enable --now topgrade.{timer,service}.` To override the timer settings, create `/etc/systemd/system/topgrade.timer/override.conf`.

## GNOME Extensions
The following extensions are explicitly installed via `gnome-extensions` module. Eventually will be replaced with GSettings schemas. 

- Alphabetical App Grid
- AppIndicators Support
- Blur My Shell
- Dash-to-Dock
- Caffeine
- Just Perfection
- Light Style
- Logo Menu
- Night Theme Switcher

# Installation

You can install by rebasing from Silverblue or generating an ISO file yourself. If you decide to give this a go, and would like to provide feedback and/or suggestions, feel free to open a new issue!

## Rebase
To rebase from a Silverblue installation, follow the steps below.

### T480/s image
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
