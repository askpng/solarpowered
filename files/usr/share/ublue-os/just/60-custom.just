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

# install arch, debian, bluebuild-cli distroboxes
# needs distrobox.ini
assemble-containers:
     distrobox assemble create --file "/etc/distrobox/distrobox.ini"

# install Arch Linux box for CLI & media player use
init-box:
     distrobox-assemble create --name box --file="/etc/distrobox.ini"

# install Arch Linux box for games
init-gamebox:
     distrobox-assemble create --name gamebox --file="/etc/distrobox.ini"

# set junction as default for browsers
setup-junction:
     xdg-settings set default-web-browser re.sonny.Junction.desktop

# install flameshot and grant screenshot permission
setup-flameshot:
     flatpak install --noninteractive --assumeyes org.flameshot.Flameshot
     flatpak permission-set screenshot screenshot org.flameshot.Flameshot yes
