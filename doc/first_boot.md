# Quick setup

The steps below (except creating project specific boxes) are automated by `pleiades-setup`. Run it as your normal user in the local session, then reboot:

```
pleiades-setup              # all steps
pleiades-setup incus        # only some steps
pleiades-setup --list       # show available steps
```

The steps are safe to re-run. The sections below describe what each step does, for doing it by hand.

# Check shell

The image sets zsh as the default shell for new users. Check it:

```
echo $SHELL
```

Only if it is not `/usr/bin/zsh`:

```
sudo usermod -s /usr/bin/zsh <username>
```

# Pull config files

```
git clone --recurse-submodules https://github.com/NMD03/dotfiles ~/.dotfiles
cd ~/.dotfiles
make
```

# Install default flatpak apps

Run this in the local session (not over SSH), polkit allows it for `wheel` users there.

```
install_pleiades_flatpak
```

## Element

Element is installed by the step above, which also lets it access the keyring.
Electron doesn't detect the keyring on sway, so start it once with:

```
flatpak run im.riot.Riot --password-store=gnome-libsecret
```

Element remembers the setting; afterwards it can be started normally.

# Setup Incus

The root subuid/subgid range is shipped with the image (`/etc/subuid`, `/etc/subgid`).

```
sudo usermod -aG incus-admin <username>
sudo incus admin init
```

The group membership takes effect after the reboot at the end.

# Podman API (compose)

Enables the rootless Docker-compatible API, so `podman compose` (backed by
`docker-compose`) can run compose projects, including `develop: watch`:

```
systemctl --user enable --now podman.socket
```

Example:

```
podman compose -f compose.yaml -f compose.dev.yaml up --build --watch
```

# Distrobox

Requires the dotfiles step above (`assemble.ini` comes from there).

```
distrobox assemble create --file ~/.config/distrobox/assemble.ini
distrobox enter fedora-dev -- true
distrobox enter ubuntu-dev -- true
podman commit fedora-dev localhost/fedora
podman commit ubuntu-dev localhost/ubuntu
```

New project boxes, the `tools` box and exporting tools to the host:
see [distrobox.md](./distrobox.md).

# Backups (optional)

Not part of the default steps. Installs the Backrest backup UI, see
[backup.md](./backup.md):

```
pleiades-setup backrest
```

# Steam (optional)

Not part of the default steps. Installs Steam as Flatpak
(`com.valvesoftware.Steam`); controller support comes from the
`steam-devices` rules already in the image:

```
pleiades-setup steam
```

For Windows games enable Steam Play (Proton) in Steam's settings. Needs Intel
or AMD graphics; NVIDIA requires an NVIDIA-enabled base image.

# Reboot
```
reboot
```
