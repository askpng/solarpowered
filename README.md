# solarpowered
[![build-ublue](https://github.com/askpng/solarpowered/actions/workflows/build.yml/badge.svg)](https://github.com/askpng/solarpowered/actions/workflows/build.yml)

> This image is set to automatically build every day at 17:30 UTC and upon `recipes/*.yml` updates.

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

These icon themes are also installed.

- `morewaita-icon-theme`
- `numix-icon-theme`
- `papirus-icon-theme`

These fonts are installed via the `fonts` module.

- Jet Brains Mono
- Nerd Fonts Symbols Only
- Martian Mono
- Ruda
- PT Sans
- Fira Sans
- Inter... is currently not included due to weird rendering issues. I hope it returns soon, but for the time being I'm alright alternating between Fira Sans and Cantarell!

The following packages are removed from the base image.
- `firefox` and `firefox-langpacks` - Firefox will be installed as a Flatpak
- `htop`
- `nvtop`
- Gnomies I don't use: `gnome-software-rpm-ostree`, `gnome-tour`, `gnome-terminal`, `gnome-terminal-nautilus`, and `yelp`
- GNOME Classic: `gnome-classic-session`, `gnome-classic-session-xsession`

### T480/s exclusive packages
The following packages are installed by default for improving Lenovo T480/s power management, performance, and features:
- `python-validity` forked by [sneexy](https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/)
- `tlp` and `tlp-rdw`
- `throttled`
> `throttled` is shipped with [default values](https://github.com/erpalma/throttled/blob/master/etc/throttled.conf) but slightly different defaults. I use universal values for AC and battery so there is no `[UNDERVOLT.AC]` nor `[UNDERVOLT.BATTERY]`, only `[UNDERVOLT]`. Documented in the `throttled` [README](https://github.com/erpalma/throttled#undervolt).
- `zcfan` for easy and straightforward fan control
> `zcfan` needs `rpm-ostree kargs --append=thinkpad_acpi.fan_control=1` to work.

The following packages are explicitly removed from the base image due to conflicts.
- `fprintd`
- `fprintd-pam`
- `power-profiles-daemon`
- `thermald`

`tlp.service` is enabled by default. `systemd-rfkill.{service,socket}` is disabled by default. Eventually, I would like to enable `python-validity`, `throttled` and `zcfan` services by default as well if possible.

## EX/desktop exclusive packages
This is a work-in-progress. My computer system will be AMD, so I am looking into things that I will need to do and/or install. So far I have decided on:

- `system76-scheduler` from [kylegospo/system76-scheduler](https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/)
- `gnome-shell-extension-system76-scheduler`

## Automatic updates
`rpm-ostreed-automatic.timer` is set to 17:45 UTC.

## Flatpak
The following apps are installed as *system* Flatpaks by default.

> Eventually Flatpaks in `default-flatpaks.yml` will be stripped down to just the bare necessities and I will be using either `yafti` or custom `just`s instead.

- BoxBuddy
- Clapper
- ExtensionManager
- FSearch
- File Roller
- Flatseal
- GNOME Clocks
- GNOME Document Viewer (Evince)
- GNOME Firmware
- GNOME Image Viewer (Loupe)
- GNOME Passwords and Keys (Seahorse)
- GNOME Text Editor
- Junction
- Mission Center
- Ptyxis
- TLP UI
- Warehouse

The following apps are installed as *user* Flatpaks by default.
- Chromium
- Easy Effects
- Firefox
- TextPieces
- Webcord

### TBA - System Flatpaks
- Evolution
- GNOME Calendar

### TBA - User Flatpaks
- Bitwarden
- Flameshot
- Fragments
- Spotify

> Alternatively, the apps above will be available for installation via `yafti`.

## Gnome Extensions
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

> Do at your own risk. This build is a heavy work in progress and ~~even I don't use it on bare metal~~ I do use it on my personal/work/production device, but I guarantee nothing. Changes, especially to `recipes/`, will be frequent.

This build works alright but it's still loose in a lot of places.

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

## T480/s image
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

### Via Docker
```
mkdir ./iso-output
sudo docker run --rm --privileged --volume ./iso-output:/build-container-installer/build --pull=always \
ghcr.io/jasonn3/build-container-installer:latest \
IMAGE_REPO=ghcr.io/askpng \
IMAGE_NAME=pbuild \
IMAGE_TAG=latest \
VARIANT=Silverblue
```

### Via Podman
```
mkdir ./iso-output
sudo podman run --rm --privileged --volume ./iso-output:/build-container-installer/build --security-opt label=disable --pull=newer \
ghcr.io/jasonn3/build-container-installer:latest \
IMAGE_REPO=ghcr.io/askpng \
IMAGE_NAME=pbuild \
IMAGE_TAG=latest \
VARIANT=Silverblue
```

## Verification
These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign).

### Verify `cosign.pub`

```bash
cosign verify --key cosign.pub ghcr.io/askpng/pbuild
```
