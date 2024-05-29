# solarpowered [![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build.yml)

> This image is set to automatically build every day at 17:00 UTC on Tuesdays and Fridays and upon `recipes/*.yml` updates.

| <center>fastfetch preview</center> |
| --- |
| ![fetch preview](/config/files/usr/etc/fastfetch/sample.webp) |


This build is a (hopefully) long-term learning project. My main goal is to better understand OCI conceptually and practically - another goal is to eventually end up with the ideal base image for my laptop and future devices.

Previously I had made [pbuild](https://github.com/askpng/pbuild). I decided to recreate `pbuild` into `solarpowered` to start afresh (well, not really).

This project would not be possible without the power of [BlueBuild](https://blue-build.org/how-to/setup/).

## Why 'solarpowered'?
I like Gawain from Fate/Grand Order.

# Image details
- [BlueBuild Template](https://github.com/blue-build/template) with actions set up
- [silverblue-main](https://github.com/ublue-os/main/pkgs/container/silverblue-main) as base image. `40` only; will advance to 41 about a month after it releases.

## Default packages
In addition to the default packages installed in the `silverblue-main` base image, the following packages are installed by default. 

> Packages are being adjusted daily and the README is not always up-to-date. Refer to the `.yml`s instead.

- `butter` by [zhangyuannie](https://github.com/zhangyuannie/butter)
- `blackbox-terminal`, eventually will be replaced with Ptyxis
- `epson-inkjet-printer-escpr` and `epson-inkjet-printer-escpr2`
- `fastfetch`
- `fish`
- `firewall-config`
- `gnome-shell-extension-gsconnect` to ensure all dependencies are installed
- `ibus-mozc` for experimental purposes (`ibus-anthy` has better toggles for non-JIS keyboards)
- `igt-gpu-tools`
- `open-any-terminal` from [julianve/open-any-terminal](https://copr.fedorainfracloud.org/coprs/julianve/open-any-terminal)
- `pulseaudio-utils`
- `thefuck` - a must have!
- `wl-clipboard`

The following packages are removed from the base image.
- `firefox` and `firefox-langpacks` - Firefox will be installed as a Flatpak
- `htop`
- `nvtop`
- GNOMies I don't use: `gnome-software-rpm-ostree`, `gnome-tour`, `gnome-terminal`, `gnome-terminal-nautilus`, and `yelp`
- GNOME Classic: `gnome-classic-session`, `gnome-classic-session-xsession`

### Icons
These icon themes are installed.

- Morewaita
- Numix
- Papirus

### Fonts
These fonts are installed via the `fonts` module.

- Fira Sans
- JetBrains Mono
- Nerd Fonts Symbols Only
- Martian Mono
- Ruda
- PT Sans
- Ubuntu and Ubuntu Mono

Inter is currently not included due to weird rendering issues. I hope it returns soon, but for the time being I'm alright alternating between Fira Sans and Cantarell!

## T480/s exclusive packages
The following packages are installed by default for improving Lenovo T480/s power management, performance, and features:
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

## EX/desktop exclusive packages
This is a work-in-progress. My computer system will be AMD, so I am looking into things that I will need to do and/or install. So far I have decided on:

- `system76-scheduler` and `gnome-shell-extension-system76-scheduler` from [kylegospo/system76-scheduler](https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/)

## Automatic updates
`rpm-ostreed-automatic.timer` is set to 17:45 UTC. Feel free to override in `/etc/systemd/system/rpm-ostreed-automatic.timer.d/override.conf`.

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
- QSTweak

# Installation

> Do at your own risk. This build is a heavy work in progress and ~~even I don't use it on bare metal~~ I do use it on my personal/work/production device, but I guarantee nothing. Changes will be frequent.

This build works pretty decently but it's still loose in a lot of places.

If you managed to even get here and read this far, first of all, why? Second of all, maybe you shouldn't, but if you insist, do try out and help me make this a better build (please).

## Rebase
To rebase from a Silverblue installation, follow the steps below.

## T480/s image
1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarpowered:latest --reboot
  ```
2. Rebase to the signed image and reboot:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarpowered:latest --reboot
  ```

## EX/desktop image
1. Rebase to the unsigned image to get the proper signing keys + policies installed and reboot:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/askpng/solarpowered-ex:latest --reboot
  ```
2. Rebase to the signed image and reboot:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/askpng/solarpowered-ex:latest --reboot
  ```

## ISO
ISO file for a fresh install can be generated using `docker` or `podman` from a Silverblue system.

> For the EX/desktop version, append `-ex` to `solarpowered`.

### Via Docker
```
mkdir ./iso-output
sudo docker run --rm --privileged --volume ./iso-output:/build-container-installer/build --pull=always \
ghcr.io/jasonn3/build-container-installer:latest \
IMAGE_REPO=ghcr.io/askpng \
IMAGE_NAME=solarpowered \
IMAGE_TAG=latest \
VARIANT=Silverblue
```

### Via Podman
```
mkdir ./iso-output
sudo podman run --rm --privileged --volume ./iso-output:/build-container-installer/build --security-opt label=disable --pull=newer \
ghcr.io/jasonn3/build-container-installer:latest \
IMAGE_REPO=ghcr.io/askpng \
IMAGE_NAME=solarpowered \
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
