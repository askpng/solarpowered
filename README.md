# <center>☀️ solarpowered ☀️</center>

I started solarpowered as a learning project. My main goal is to better understand OCI images as a concept and in practice. Another goal is to eventually end up with the ideal base image for my laptop and future devices.

Solarpowered without a doubt contains errors and roundabout approaches. I *am* however learning to correct these errors and find more straightforward means of achieving what I want!

## Why did you name this 'solarpowered'?
Because I like Gawain from Fate/Extra & Fate/Grand Order.

## Fetch?

Fetch. (More will come!)

![solarpowered fastfetch](/config/files/usr/etc/fastfetch/sample.png)

# Image details
- [BlueBuild Template](https://github.com/blue-build/template) with actions set up. WIthout BlueBuild, I would never have come up with the idea of exploring OCI images.
- [silverblue-main](https://github.com/ublue-os/main/pkgs/container/silverblue-main) as base image for solarpowered and solarpowered-ex.
- [Bluefin](https://github.com/ublue-os/bluefin) as base image for solarpowered-pro.

## Build status
<center>

| | solarpowered / T480s image | solarpowered-ex / desktop image | solarpowered-pro / HIGHLY EXPERIMENTAL |
| --- | --- | --- | --- |
| **Status** | <center> [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build.yml) </center> | <center> [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build-ex.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-ex.yml) </center> | <center> [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build-pro.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build-pro.yml) </center> |
| **Description** | This image contains packages optimized for Lenovo T480s. | This image is a work-in-progress for my future AMD desktop. | This is an experimental build which tweaks [Bluefin](https://github.com/ublue-os/bluefin). |
| **Scheduled build** | 17:00 UTC on Tuesdays | 17:00 UTC on Saturdays | 17:00 UTC on Saturdays |

</center>

## Packages

In addition to the default packages installed in the `silverblue-main` base image, the following packages are installed by default. 

> Packages are being adjusted very frequently and the README is not always up-to-date. Refer to the `.yml`s instead.

- `butter` by [zhangyuannie](https://github.com/zhangyuannie/butter) for BTRFS snapshots
- `blackbox-terminal` as the default fallback terminal
- `epson-inkjet-printer-escpr` and `epson-inkjet-printer-escpr2`
- `fastfetch`
- `fish`
- `firewall-config`
- `gnome-shell-extension-gsconnect` and `nautilus-gsconnect`
- `lm_sensors`
- `pulseaudio-utils`
- `wl-clipboard`

The following packages are removed from the base image.
- `firefox` and `firefox-langpacks` - Firefox will be installed as a Flatpak
- `htop`
- `nvtop`
- `vim-enhanced`
- GNOMies I don't use: `gnome-software-rpm-ostree`, `gnome-tour`, `gnome-terminal`, `gnome-terminal-nautilus`, and `yelp`
- GNOME Classic: `gnome-classic-session`, `gnome-classic-session-xsession`
- Default GNOME Extensions: Apps Menu, Background Logo, Launch new instance, Places Menu, and Windows List

### Icons
These icon themes are installed.

- [Morewaita](https://github.com/somepaulo/MoreWaita)
- [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)

### Fonts
These fonts are installed via the `fonts` module.

- JetBrains Mono
- [Kosugi Maru](https://fonts.google.com/specimen/Kosugi+Maru)
- [Martian Mono](https://fonts.google.com/specimen/Martian+Mono)
- Nerd Fonts Symbols Only
- [Ruda](https://fonts.google.com/specimen/Ruda)
- Ubuntu, Ubuntu Mono

### solarpowered: T480/s exclusive packages
The following packages are installed by default for improving Lenovo T480/s power management, performance, and features:
- `igt-gpu-tools` for monitoring GPU use
- `python-validity` forked by [sneexy](https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/)
- `tlp` and `tlp-rdw`
- `throttled`
> `throttled` is shipped with [default values](https://github.com/erpalma/throttled/blob/master/etc/throttled.conf) but slightly different defaults. I use universal values for AC and battery so there is no `[UNDERVOLT.AC]` nor `[UNDERVOLT.BATTERY]`, only `[UNDERVOLT]`. Documented in the `throttled` [README](https://github.com/erpalma/throttled#undervolt).
- `zcfan` for easy and straightforward fan control
> `zcfan` needs `rpm-ostree kargs --append=thinkpad_acpi.fan_control=1` to work. You can also run `ujust --choose` and select `set-kargs` to apply it with other kernel parameters.

The following packages are explicitly removed from the base image due to conflicts.
- `fprintd`
- `fprintd-pam`
- `power-profiles-daemon`
- `thermald`

`tlp.service` is enabled by default. `systemd-rfkill.{service,socket}` is disabled by default.

### solarpowered-ex: Desktop exclusive packages
This is a work-in-progress. My computer system will be AMD, so I am looking into things that I will need to do and/or install. So far I have decided on:

- `system76-scheduler` and `gnome-shell-extension-system76-scheduler` from [kylegospo/system76-scheduler](https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/)
- `lact` from [matte-schwartz](https://copr.fedorainfracloud.org/coprs/matte-schwartz/lact/)
- [radeontop](https://packages.fedoraproject.org/pkgs/radeontop/radeontop)

## Automatic updates
`rpm-ostreed-automatic.timer` is set to 17:45 UTC daily. Feel free to override in `/etc/systemd/system/rpm-ostreed-automatic.timer.d/override.conf`.

## Flatpak
The following apps are installed as *system* Flatpaks by default.

> Eventually Flatpaks in `default-flatpaks.yml` will be stripped down to just the essentials; the remaining system and user Flatpaks will be available for batch installation via `ujust` scripts.

- Clapper
- Extension Manager
- File Roller
- Flatseal
- GNOME Clocks
- GNOME Document Viewer (Evince)
- GNOME Firmware
- GNOME Image Viewer (Loupe)
- GNOME Passwords and Keys (Seahorse)
- GNOME Text Editor
- GNOME Weather
- Junction
- Ptyxis
- Warehouse

### TBA - System Flatpaks
- Evolution
- GNOME Calendar

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
- ~~QSTweak~~ currently not included due to the changes in the BlueBuild `gnome-extensions` module

# Installation

> Do at your own risk. This build is a heavy work in progress and ~~even I don't use it on bare metal~~ while I do use it on my personal/work/production device, I cannot guarantee it will run 100% well on yours. Changes will be frequent, breaking or not.

If you managed to even get here and read this far, first of all, why? Second of all, maybe you shouldn't, but if you insist, do try out and help me make this a better build (please).

## Rebase
To rebase from a Silverblue installation, follow the steps below.

## T480/s image
1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot automatically:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarpowered:latest --reboot
  ```
2. Rebase to the signed image and reboot automatically:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarpowered:latest --reboot
  ```

## EX/desktop image
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

> For the EX/desktop version, append `-ex` to `solarpowered`.

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
