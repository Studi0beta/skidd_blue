#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

# The COPR supplies a newer Hyprland than Fedora stable. Disable it after the
# transaction so installed systems do not use it for future package layering.
dnf5 -y copr enable lionheartp/Hyprland
dnf5 install -y \
    hypridle \
    hyprland \
    hyprlock \
    hyprpaper \
    hyprpolkitagent \
    xdg-desktop-portal-hyprland
dnf5 -y copr disable lionheartp/Hyprland

dnf5 install -y \
    brightnessctl \
    fish \
    ghostty \
    helix \
    noctalia \
    playerctl \
    wl-clipboard

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
