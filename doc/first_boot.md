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

# Setup Incus

The root subuid/subgid range is shipped with the image (`/etc/subuid`, `/etc/subgid`).

```
sudo usermod -aG incus-admin <username>
sudo incus admin init
```

The group membership takes effect after the reboot at the end.

# Distrobox

Requires the dotfiles step above (`assemble.ini` comes from there).

```
distrobox assemble create --file ~/.config/distrobox/assemble.ini
distrobox enter fedora-dev -- true
distrobox enter ubuntu-dev -- true
podman commit fedora-dev localhost/fedora
podman commit ubuntu-dev localhost/ubuntu
```

## Create project specific boxes:
```
distrobox create \
    --name <project-name> \
    --image localhost/<OS>
```

# Reboot
```
reboot
```
