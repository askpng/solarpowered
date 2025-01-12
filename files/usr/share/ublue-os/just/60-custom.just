# set kernel parameters for sysrq, thinkpad fan control, and i915 guc-fbc
t480s-kargs:
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
gnome-vrr:
     gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"

# set amd_pstate=enable kernel and amdgpu.ppfeaturemask argument for amd_pstate_epp and amdgpu control
kargs-essential-amd:
     rpm-ostree kargs \
       --append-if-missing=amd_pstate=active \
       --append-if-missing=$(printf 'amdgpu.ppfeaturemask=0x%x\n' "$(($(cat /sys/module/amdgpu/parameters/ppfeaturemask) | 0x4000))")

# set kernel arguments for sysrq, memory shuffle & apple keyboard drivers
kargs-essential:
     rpm-ostree kargs \
       --append-if-missing=sysrq_always_enabled=1 \
       --append-if-missing=page_alloc.shuffle=1 \
       --append-if-missing=hid_apple.fnmode=0
    
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

# anbox-modules
anbox-modules-install:
     sudo dkms install anbox-ashmem/1
     sudo dkms install anbox-binder/1
     sudo modprobe ashmem_linux
     sudo modprobe binder_linux
     lsmod | grep -e ashmem_linux -e binder_linux
     ls -alh /dev/binder /dev/ashmem

# anbox-modules
anbox-modules-uninstall:
     sudo dkms remove anbox-ashmem/1
     sudo dkms remove anbox-binder/1
     failed_checks=0
     if sudo modprobe ashmem_linux > /dev/null 2>&1; then
          failed_checks=1
     else
          failed_checks=0
     fi

     if sudo modprobe binder_linux > /dev/null 2>&1; then
          failed_checks=1
     else
          failed_checks=0
     fi

     if lsmod | grep -e ashmem_linux -e binder_linux > /dev/null 2>&1; then
          failed_checks=1
     else
          failed_checks=0
     fi

     if ls -alh /dev/binder /dev/ashmem > /dev/null 2>&1; then
          failed_checks=1
     else
          failed_checks=0
     fi

     if [ $failed_checks == 1 ]; then
          echo "Please restart your device and rerun this script to verify changes"
     else
          echo "Modules not installed"
     fi