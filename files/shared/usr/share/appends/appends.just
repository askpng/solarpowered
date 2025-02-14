# T480s setup in one go
solarpowered-setup:
    rpm-ostree kargs \
      --append-if-missing="thinkpad_acpi.fan_control=1" \
      --append-if-missing="i915.enable_guc=2" \
      --append-if-missing="i915.enable_fbc=1" \
      --append-if-missing="sysrq_always_enabled=1" \
      --append-if-missing="page_alloc.shuffle=1" \
      --append-if-missing="hid_apple.fnmode=0"
    sudo systemctl enable zcfan.service
    sudo systemctl start python3-validity.service
    sudo systemctl start open-fprintd.service
    sudo systemctl enable open-fprintd-resume.service open-fprintd-suspend.service open-fprintd.service python3-validity.service
    sudo authselect enable-feature with-fingerprint
    sudo authselect apply-changes
    sudo authselect current     
    flatpak install --system flathub --noninteractive --assumeyes \
      com.github.d4nj1.tlpui

# AMDPC setup in one go
solarpowered-ex-setup:
     rpm-ostree kargs \
       --append-if-missing=amd_pstate=active \
       --append-if-missing=$(printf 'amdgpu.ppfeaturemask=0x%x\n' "$(($(cat /sys/module/amdgpu/parameters/ppfeaturemask) | 0x4000))") \
       --append-if-missing="sysrq_always_enabled=1" \
       --append-if-missing="page_alloc.shuffle=1" \
       --append-if-missing="hid_apple.fnmode=0"
     gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"

# configure experimental GNOME VRR
gnome-vrr:
     gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"

# set junction as default for browsers
setup-junction:
     xdg-settings set default-web-browser re.sonny.Junction.desktop

# install flameshot and grant screenshot permission
setup-flameshot:
     flatpak install --noninteractive --assumeyes org.flameshot.Flameshot
     flatpak permission-set screenshot screenshot org.flameshot.Flameshot yes

# Setup box
box:
     distrobox-assemble create --file https://raw.githubusercontent.com/askpng/box/refs/heads/main/box.ini
     distrobox-enter box

# Setup gamebox
gaming-box:
     distrobox-assemble create --file https://raw.githubusercontent.com/askpng/box/refs/heads/main/gaming-box.ini
     distrobox-enter gaming-box

# Setup bluebuild-cli
bluebuild-cli:
     distrobox-assemble create --file /etc/distrobox.ini -n bluebuild-cli
     distrobox-enter bluebuild-cli

# Boot into this device's BIOS/UEFI screen
bios:
    #!/usr/bin/bash
    if [ -d /sys/firmware/efi ]; then
      systemctl reboot --firmware-setup
    else
      echo "Rebooting to legacy BIOS from OS is not supported."
    fi

# Regenerate GRUB config
regenerate-grub:
    #!/usr/bin/env bash
    if [ -d /sys/firmware/efi ]; then
      sudo grub2-mkconfig -o /etc/grub2-efi.cfg
    else
      sudo grub2-mkconfig -o /etc/grub2.cfg
    fi

# Check for local overrides
check-local-overrides:
    #!/usr/bin/env bash
    diff -r \
      --suppress-common-lines \
      --color="always" \
      --exclude "passwd*" \
      --exclude "group*" \
      --exclude="subgid*" \
      --exclude="subuid*" \
      --exclude="machine-id" \
      --exclude="adjtime" \
      --exclude="fstab" \
      --exclude="system-connections" \
      --exclude="shadow*" \
      --exclude="gshadow*" \
      --exclude="ssh_host*" \
      --exclude="cmdline" \
      --exclude="crypttab" \
      --exclude="hostname" \
      --exclude="localtime" \
      --exclude="locale*" \
      --exclude="*lock" \
      --exclude=".updated" \
      --exclude="*LOCK" \
      --exclude="vconsole*" \
      --exclude="00-keyboard.conf" \
      --exclude="grub" \
      --exclude="system.control*" \
      --exclude="cdi" \
      --exclude="default.target" \
      /usr/etc /etc 2>/dev/null | sed '/Binary\ files\ /d'

# Show changelog between deployments
changelogs:
    rpm-ostree db diff --changelogs

# Clean up old up unused podman images, volumes, flatpak packages and rpm-ostree content
clean-system:
    #!/usr/bin/env bash
    podman image prune -af
    podman volume prune -f
    flatpak uninstall --unused
    rpm-ostree cleanup -bm