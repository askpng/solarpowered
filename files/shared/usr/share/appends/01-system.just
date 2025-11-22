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
    podman image prune -af
    podman volume prune -f
    flatpak uninstall --unused
    rpm-ostree cleanup -bm

# Renew IP & flush DNS
reset-address:
     sudo nmcli device disconnect enp4s0
     sudo nmcli device connect enp4s0
     sudo systemctl restart systemd-resolved
     systemd-resolve --status

# Enable iwd, disable wpa_supplicant
enable-iwd:
	#!/usr/bin/env bash
	sudo systemctl disable --now wpa_supplicant
	sudo systemctl mask wpa_supplicant
	mkdir -Z /etc/NetworkManager/conf.d
	sudo cat > /etc/NetworkManager/conf.d/iwd.conf <<EOF
	[device]
	wifi.backend=iwd
	EOF
	restorecon -R /etc/NetworkManager
	sudo systemctl restart NetworkManager

# Disable iwd, reenable wpa_supplicant
disable-iwd:
	sudo mv "/etc/NetworkManager/conf.d/iwd.conf" "/etc/NetworkManager/conf.d/iwd.conf.off"
	sudo systemctl disable --now iwd
	sudo systemctl unmask wpa_supplicant
	sudo systemctl enable --now wpa_supplicant
	sudo systemctl restart NetworkManager