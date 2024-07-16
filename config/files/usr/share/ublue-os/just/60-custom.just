# set kernel parameters for sysrq, thinkpad fan control, and i915 guc-fbc
t480s-set-kargs:
    rpm-ostree kargs \
      --append-if-missing="thinkpad_acpi.fan_control=1" \
      --append-if-missing="i915.enable_guc=2" \
      --append-if-missing="i915.enable_fbc=1"

# install t480s flatpaks
# - tlp ui
t480s-install-flatpaks:
    flatpak install --system flathub --noninteractive --assumeyes \
         com.github.d4nj1.tlpui

# configure T480s fingerprint sensor
t480s-set-fingerprint-sensor:
     sudo systemctl start python3-validity.service
     sudo systemctl start open-fprintd.service
     sudo systemctl enable open-fprintd-resume.service open-fprintd-suspend.service open-fprintd.service python3-validity.service
     sudo authselect enable-feature with-fingerprint
     sudo authselect apply-changes
     sudo authselect current

# configure experimental GNOME VRR
ex-gnome-vrr:
     gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"

# set kernel arguments for sysrq, memory shuffle & apple keyboard drivers
set-essential-kargs:
     rpm-ostree kargs \
          --append-if-missing="sysrq_always_enabled=1" \
          --append-if-missing=page_alloc.shuffle=1 \
          --append-if-missing=hid_apple.fnmode=0

# install user flatpak selection
install-user-flatpaks:
     flatpak install --user flathub --noninteractive --assumeyes \
         com.vscodium.codium \
         com.bitwarden.desktop \
         com.quexten.Goldwarden \
         de.haeckerfelix.Fragments \
         io.github.cboxdoerfer.FSearch \
         io.github.nokse22.minitext \
         io.github.quodlibet.QuodLibet \
         io.github.shiftey.Desktop \
         io.github.milkshiift.GoofCord \
         io.gitlab.librewolf-community \
         io.github.seadve.Kooha \
         org.chromium.Chromium \
         page.codeberg.libre_menu_editor.LibreMenuEditor

# install system flatpaks selection
install-system-flatpaks:
     flatpak install --system flathub --noninteractive --assumeyes \
         com.bitwarden.desktop \
         com.github.wwmm.easyeffects \
         com.spotify.Client \
         io.github.dvlv.boxbuddyrs \
         org.mozilla.firefox
     
# install arch, debian, bluebuild-cli distroboxes
# needs distrobox.ini
assemble-containers:
     distrobox assemble create --file /etc/distrobox/distrobox.ini

# set junction as default for browsers
set-junction:
     xdg-settings set default-web-browser re.sonny.Junction.desktop

# install flameshot and grant screenshot permission
set-flameshot:
     flatpak install --user --noninteractive --assumeyes org.flameshot.Flameshot
     flatpak permission-set screenshot screenshot org.flameshot.Flameshot yes

