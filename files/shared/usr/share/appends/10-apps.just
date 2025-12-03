# Setup box
box:
     distrobox-assemble create --file https://raw.githubusercontent.com/askpng/box/refs/heads/main/box.ini
     distrobox-start boxit

# set junction as default for browsers
setup-junction:
     xdg-settings set default-web-browser re.sonny.Junction.desktop

# install flameshot and grant screenshot permission
setup-flameshot:
     flatpak install --noninteractive --assumeyes org.flameshot.Flameshot
     flatpak permission-set screenshot screenshot org.flameshot.Flameshot yes

# Scripts to initialize, configure, integrate & reset Waydroid
setup-waydroid:
     #!/usr/bin/env bash
     set -e

     if [ "$OPTION" == "" ]; then
     echo "${bold}Waydroid utilities${normal}"
     PS3="Please select an option: "
     select OPTION in "Initialize Waydroid" "Configure Waydroid" "Enable fake touch" "Set as Nicole" "Install APKCombo installer and Material Files" "Logs, clean version" "Reset Waydroid (also removes waydroid-related files from user folder)"; do
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
          echo "waydroid init -s VANILLA -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'"
          sudo waydroid init -s VANILLA -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'
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

     elif [[ "${OPTION,,}" =~ ^enable ]]; then
          echo "Setting fake touch for Aniplex apps..."
          waydroid prop set persist.waydroid.fake_touch "com.aniplex.*"

     elif [[ "${OPTION,,}" =~ ^set ]]; then
          echo "curl -L 'https://raw.githubusercontent.com/askpng/waydroid_script/refs/heads/main/scripts/nicole.sh' -o /tmp/nicole.sh"
          curl -L 'https://raw.githubusercontent.com/askpng/waydroid_script/refs/heads/main/scripts/nicole.sh' -o /tmp/nicole.sh
          echo "chmod +x /tmp/nicole.sh"
          chmod +x /tmp/nicole.sh
          echo "sudo bash -c /tmp/nicole.sh"
          sudo bash -c /tmp/nicole.sh
          echo "rm -f /tmp/nicole.sh"
          rm -f /tmp/nicole.sh

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