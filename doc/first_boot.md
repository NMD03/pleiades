# Change shell for user

```
sudo usermod -s /usr/bin/zsh <username>
```

# Pull config files and update

```
git clone --recurse-submodules https://github.com/NMD03/dotfiles ~/.dotfiles
cd ~/.dotfiles 
make
```

# Install default flatpak apps

```
install_pleiades_flatpak
```

# Setup Incus

```
sudo usermod -aG incus-admin <username>
newgrp incus-admin
sudo incus admin init
sudo sh -c 'echo "root:1000000:1000000000" >> /etc/subuid'
sudo sh -c 'echo "root:1000000:1000000000" >> /etc/subgid'
sudo systemctl restart incus
```

# Distrobox

```
distrobox assemble create
podman commit fedora-dev localhost/fedora
podman commit ubuntu-dev localhost/ubuntu
```

## Create project specific boxes:
```
distrobox create \
    --name <project-name> \
    --image localhost/<OS>
```
