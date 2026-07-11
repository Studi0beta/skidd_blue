# skidd_blue

`skidd_blue` is a public Universal Blue image for NVIDIA desktop and laptop gaming systems. It derives from Bazzite's NVIDIA KDE Plasma image, with Hyprland as an additional desktop session and Plasma retained as a fallback.

## Included

- Bazzite's proprietary NVIDIA driver, Steam, gaming tools, Bluetooth stack, and controller support
- KDE Plasma as a fallback session in SDDM
- Current Hyprland packages from the LionHeartP COPR, installed at image build time
- Noctalia v5, Helix, Ghostty, Fish, eza, Zoxide, Hyprlock, Hypridle, Hyprpaper, and Hyprland's portal
- A starter Hyprland configuration for new user accounts that starts Noctalia and configures common keybindings
- Ghostty, Helix, and Fish defaults, including bundled Tide, fzf.fish, and plugin-git Fish plugins

The image is published to `ghcr.io/studi0beta/skidd_blue:latest`.

## Build Setup

This repository builds on pushes to `main` and once daily. GitHub Actions publishes a signed, rechunked OCI image to GHCR.

Generate a signing key once:

```bash
COSIGN_PASSWORD="" cosign generate-key-pair
```

Commit `cosign.pub`, but never commit `cosign.key`. Add the contents of `cosign.key` as the `SIGNING_SECRET` repository Actions secret:

```bash
gh secret set SIGNING_SECRET < cosign.key
```

Build locally:

```bash
just check
just lint
sudo just build
sudo just ostree-rechunk
```

Push the image recipe after validation:

```bash
git add .
git commit -m "Configure skidd_blue image"
git push
```

## Install Or Switch

From a bootc-compatible system such as Bazzite, switch to the public image:

```bash
sudo bootc switch ghcr.io/studi0beta/skidd_blue:latest
systemctl reboot
```

No registry credentials are required. At SDDM, select **Hyprland** for the custom session or **Plasma** for the fallback session.

To use the starter configuration with an account that already exists, copy it once before logging into Hyprland:

```bash
mkdir -p ~/.config/hypr
cp /etc/skel/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
```

New accounts receive the configuration automatically. Fish is the default shell for accounts created after this image is installed; rebasing does not alter existing users' shells.

## Hyprland Keys

- `Super` + `Return`: Ghostty
- `Super` + `Space`: Noctalia launcher
- `Super` + `S`: Noctalia control center
- `Super` + `C`: close active window
- `Super` + `1` through `5`: switch workspace
- `Super` + `Shift` + `1` through `5`: move active window to workspace

Noctalia v5 is currently beta. The image build explicitly fails if its package is not a v5 release.

## Verify And Roll Back

Verify a published image with the committed public key:

```bash
cosign verify --key cosign.pub ghcr.io/studi0beta/skidd_blue:latest
```

If an update fails after rebooting, select the previous deployment in the boot menu or run:

```bash
sudo bootc rollback
systemctl reboot
```

## Disk Images

Run the **Build disk images** workflow manually to create a QCOW2 image or Anaconda ISO. The ISO configuration deploys `ghcr.io/studi0beta/skidd_blue:latest` during installation.
