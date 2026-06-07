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
