# skidd_blue Agent Notes

## Project Purpose

`skidd_blue` is a public Universal Blue bootc image for NVIDIA desktops and laptops. It is published as `ghcr.io/studi0beta/skidd_blue:latest`.

The image derives from `ghcr.io/ublue-os/bazzite-gnome-nvidia:stable`. GNOME must remain available as the GDM fallback session; Hyprland is the primary custom session.

## Image Contents

- Bazzite NVIDIA gaming stack, Bluetooth, and controller support come from the base image.
- Hyprland and companion packages come from `lionheartp/Hyprland` COPR during image build only.
- Ghostty comes from `scottames/ghostty` COPR during image build only.
- Both COPRs must be disabled after package installation.
- Noctalia must be v5. The build deliberately fails if `noctalia` is not a v5 release.
- The image includes Helix, Fish, eza, fzf, Zoxide, Ghostty, and Hyprland utilities.

## User Defaults

Files in `system_files/etc/skel/.config/` are copied only to new accounts:

- `hypr/hyprland.conf` starts Noctalia and defines starter keybindings.
- `ghostty/config` and `helix/config.toml` mirror the desired terminal and editor defaults.
- `fish/` configures `EDITOR=hx`, Zoxide, eza-backed `ls` and `ll`, and the Fisher plugin manifest.
- `build_files/build.sh` installs Fisher, Tide v6, fzf.fish, and plugin-git into `/etc/skel` using pinned upstream commits.

Do not alter existing users' shells or configuration during a rebase. Existing users can selectively copy files from `/etc/skel`.

## Build And Signing

- GitHub Actions builds on pushes to `main` and publishes to GHCR.
- `cosign.pub` is committed. `cosign.key` is ignored and must never be committed or displayed.
- The repository Actions secret `SIGNING_SECRET` contains the private signing key.
- Use the existing GitHub Actions workflow; do not replace its rechunking or signing steps without a reason.
- The local Git identity is not configured globally. For repository commits use:

```bash
git -c user.name="Studio Beta" -c user.email="gregorado@protonmail.com" commit -m "<message>"
```

## Verification

Run before committing when available:

```bash
bash -n build_files/build.sh
git diff --check
just check
just lint
```

The local development machine may not have `just`, `podman`, or `shellcheck`; GitHub Actions is the authoritative full image-build validation.

## Current State

The image recipe has been committed through `74f471c` (`Fix pinned Fisher plugin sources`). That commit corrects an earlier build failure caused by using annotated Git tag objects instead of their peeled source commits for Fisher and Tide. Confirm the GitHub Actions build for the current `main` commit passes before rebasing any machine.

## Rebase Target

Install Bazzite GNOME NVIDIA on a new NVIDIA machine, then, after a successful custom-image build:

```bash
sudo bootc switch ghcr.io/studi0beta/skidd_blue:latest
systemctl reboot
```
