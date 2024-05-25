# set kernel parameters for sysrq, thinkpad fan control, and i915 guc-fbc
set-kargs:
    rpm-ostree kargs \
      --append-if-missing="sysrq_always_enabled=1" \
      --append-if-missing="thinkpad_acpi.fan_control=1" \
      --append-if-missing="i915.enable_guc=2" \
      --append-if-missing="i915.enable_fbc=1" \
      --append-if-missing="page_alloc.shuffle=1" \

# install user flatpak selection
install-user-flatpaks:
     flatpak install --user flathub --noninteractive --assumeyes \
     io.github.spacingbat3.webcord \
     net.waterfox.waterfox \
     com.vscodium.codium \

# enable auto update for distroboxes
distrobox-auto-update:
     systemctl enable --user distrobox-auto-update.{timer,service}

# install arch, debian, bluebuild-cli distroboxes
# needs distrobox.ini
premature-set-containers:
     distrobox assemble create

# set junction as default for browsers
set-junction:
     xdg-settings set default-web-browser re.sonny.Junction.desktop

# install flameshot and grant screenshot permission
set-flameshot:
     flatpak install --user --noninteractive --assumeyes org.flameshot.Flameshot && flatpak permission-set screenshot screenshot org.flameshot.Flameshot yes

# set python3-validity
# NEEDS VALIDATION (lol)
premature-set-fingerprint-sensor:
     sudo systemctl start python3-validity.service \
     sudo systemctl start open-fprintd.service \
     sudo systemctl enable open-fprintd-resume.service open-fprintd-suspend.service open-fprintd.service python3-validity.service \
     sudo authselect enable-feature with-fingerprint \
     sudo authselect apply-changes \
     sudo authselect current \

