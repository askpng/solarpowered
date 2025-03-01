# T480s setup in one go
solarpowered-setup:
    flatpak install --system flathub --noninteractive --assumeyes com.github.d4nj1.tlpui
    rpm-ostree kargs \
      --append-if-missing="thinkpad_acpi.fan_control=1" \
      --append-if-missing="i915.enable_guc=2" \
      --append-if-missing="i915.enable_fbc=1" \
      --append-if-missing="sysrq_always_enabled=1" \
      --append-if-missing="page_alloc.shuffle=1" \
      --append-if-missing="hid_apple.fnmode=0"
    rpm-ostree initramfs --enable
    sudo systemctl enable zcfan.service
    sudo systemctl start python3-validity.service
    sudo systemctl start open-fprintd.service
    sudo systemctl enable open-fprintd-resume.service open-fprintd-suspend.service open-fprintd.service python3-validity.service
    sudo authselect enable-feature with-fingerprint
    sudo authselect apply-changes
    sudo authselect current
    echo 'Remember to reboot!' 

# AMDPC setup in one go
solarpowered-ex-setup:
     sudo systemctl enable --now  b550-suspend-fix.service
     rpm-ostree kargs \
       --append-if-missing=amd_pstate=active \
       --append-if-missing=$(printf 'amdgpu.ppfeaturemask=0x%x\n' "$(($(cat /sys/module/amdgpu/parameters/ppfeaturemask) | 0x4000))") \
       --append-if-missing="sysrq_always_enabled=1" \
       --append-if-missing="page_alloc.shuffle=1" \
       --append-if-missing="hid_apple.fnmode=0"
     rpm-ostree initramfs --enable
     gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"
     echo 'Remember to reboot!' 

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

# Pull images needed for bluebuild-cli to run
pull-bluebuild:
    #!/usr/bin/env/bash
    echo '1/3 Pulling Cosign v2.4.2'
    podman pull ghcr.io/sigstore/cosign/cosign:v2.4.2
    echo '2/3 Pulling nushell-image'
    podman pull ghcr.io/blue-build/nushell-image
    echo '3/3 Pulling BlueBuild CLI latest-installer'
    podman pull ghcr.io/blue-build/cli:latest-installer
    echo 'Done!'

# Scripts to initialize, configure, integrate & reset Waydroid
setup-waydroid:
     #!/usr/bin/env bash

     if [ "$OPTION" == "" ]; then
     echo "${bold}Waydroid utilities${normal}"
     PS3="Please select an option: "
     select OPTION in "Initialize Waydroid" "Configure Waydroid" "Select GPU for Waydroid" "Integrate Waydroid windows with desktop" "Set Waydroid as Pixel 8" "Install APKCombo installer and Material Files" "Logs, clean version" "Reset Waydroid (also removes waydroid-related files from user folder)"; do
          if [[ -n "$OPTION" ]]; then
               break
          else
               echo "Invalid option, please try again."
          fi
     done
     fi

     if [[ "${OPTION,,}" =~ ^init ]]; then
          echo "sudo systemctl enable --now waydroid-container.service"
          sudo systemctl enable --now waydroid-container.service
          echo "sudo waydroid init -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'"
          sudo waydroid init -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'
          echo "sudo restorecon -R /var/lib/waydroid"
          sudo restorecon -R /var/lib/waydroid
          echo "cp /usr/share/applications/waydroid-container-restart.desktop ~/.local/share/applications"
          cp /usr/share/applications/waydroid-container-restart.desktop ~/.local/share/applications
          echo "Waydroid has been initialized. Before continuing, run 'waydroid session start' and ensure it is up and running well."

     elif [[ "${OPTION,,}" =~ ^configure ]]; then
          echo "git clone https://github.com/askpng/waydroid_script.git --depth 1 /tmp/waydroid_script"
          git clone https://github.com/askpng/waydroid_script.git --depth 1 /tmp/waydroid_script
          echo "python3 -m venv /tmp/waydroid_script/venv"
          python3 -m venv /tmp/waydroid_script/venv
          echo "source /tmp/waydroid_script/venv/bin/activate"
          source /tmp/waydroid_script/venv/bin/activate
          echo "sudo /tmp/waydroid_script/venv/bin/pip install -r /tmp/waydroid_script/requirements.txt"
          sudo /tmp/waydroid_script/venv/bin/pip install -r /tmp/waydroid_script/requirements.txt
          echo "/tmp/waydroid_script/venv/bin/python3 /tmp/waydroid_script/main.py"
          sudo /tmp/waydroid_script/venv/bin/python3 /tmp/waydroid_script/main.py
          echo "deactivate"
          deactivate
          echo "sudo rm -rf /tmp/waydroid_script"
          sudo rm -rf /tmp/waydroid_script ~/.cache/waydroid_script

     elif [[ "${OPTION,,}" =~ gpu ]]; then
          echo "This command is not available for use yet!"
          # sudo /usr/bin/waydroid-choose-gpu

     elif [[ "${OPTION,,}" =~ ^integrate ]]; then
          echo "waydroid prop set persist.waydroid.multi_windows true"
          waydroid prop set persist.waydroid.multi_windows true
          echo "Setting fake touch for Aniplex apps..."
          waydroid prop set persist.waydroid.fake_touch "com.aniplex.*"
          # echo "User rotation fix..."
          # sudo waydroid shell wm set-fix-to-user-rotation enabled

     elif [[ "${OPTION,,}" =~ ^set ]]; then
          echo "curl -L 'https://raw.githubusercontent.com/askpng/waydroid_script/refs/heads/main/scripts/shiba.sh' -o /tmp/shiba.sh"
          curl -L 'https://raw.githubusercontent.com/askpng/waydroid_script/refs/heads/main/scripts/shiba.sh' -o /tmp/shiba.sh
          echo "chmod +x /tmp/shiba.sh"
          chmod +x /tmp/shiba.sh
          echo "sudo bash -c /tmp/shiba.sh"
          sudo bash -c /tmp/shiba.sh
          echo "rm -f /tmp/shiba.sh"
          rm -f /tmp/shiba.sh

     elif [[ "${OPTION,,}" =~ ^install ]]; then
          echo "Installing APKCombo Installer"
          curl -L "https://static.apkflash.com/files/com.apkcombo.app/apkcombo-installer.apk" -o /tmp/apkcombo-installer.apk
          waydroid app install /tmp/apkcombo-installer.apk
          echo "Installing Material Files"
          curl -L "https://f-droid.org/repo/me.zhanghai.android.files_39.apk" -o /tmp/material-files.apk
          waydroid app install /tmp/material-files.apk
          echo "Removing .APK files"
          rm /tmp/apkcombo-installer.apk /tmp/material-files.apk
          echo "Success!"

     elif [[ "${OPTION,,}" =~ ^logs ]]; then
          echo "Grabbing clean logs..."
          sudo waydroid logcat | grep -vi controller | grep -vi mantis | grep -vi gamepad | grep -v lowmemorykiller | grep -v libprocessgroup

     elif [[ "${OPTION,,}" =~ ^reset ]]; then
          echo "Resetting Waydroid"
          echo "bash -c 'sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid'"
          bash -c 'sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid'
          echo "sudo systemctl disable --now waydroid-container.service"
          sudo systemctl disable --now waydroid-container.service
          echo "Waydroid has been reset! Re-initialize to get it back up and running."

     fi
