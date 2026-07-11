#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

# These COPRs supply Hyprland and Ghostty. Disable them after installation so
# installed systems do not use third-party repositories for package layering.
dnf5 -y copr enable lionheartp/Hyprland
dnf5 -y copr enable scottames/ghostty

dnf5 install -y \
    brightnessctl \
    fish \
    ghostty \
    helix \
    hypridle \
    hyprland \
    hyprlock \
    hyprpaper \
    hyprpolkitagent \
    noctalia \
    playerctl \
    wl-clipboard \
    xdg-desktop-portal-hyprland
dnf5 -y copr disable lionheartp/Hyprland
dnf5 -y copr disable scottames/ghostty

# Noctalia v5 is required for the supplied configuration. Do not silently
# produce an image with the older Quickshell-based v4 package.
noctalia_version=$(rpm -q --qf '%{VERSION}' noctalia)
if [[ ! ${noctalia_version} =~ ^5\. ]]; then
    echo "Noctalia v5 is required, but installed version is ${noctalia_version}." >&2
    exit 1
fi

# Apply Fish to accounts created after the image is installed. Existing users
# retain their selected shell when rebasing.
if grep -q '^SHELL=' /etc/default/useradd; then
    sed -i 's|^SHELL=.*|SHELL=/usr/bin/fish|' /etc/default/useradd
else
    printf '%s\n' 'SHELL=/usr/bin/fish' >> /etc/default/useradd
fi

# Bazzite carries the Bluetooth stack and controller drivers. Enable the
# service so adapter discovery is available immediately after installation.
systemctl enable bluetooth.service
dnf5 clean all
