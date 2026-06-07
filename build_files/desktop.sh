#!/usr/bin/bash
set -ouex pipefail

DESKTOP_PACKAGES=(
    sway 
    swaybg 
    swaylock 
    swayidle 
    alacritty 
    i3status 
    kanshi 
    dunst 
    grim 
    slurp 
    wl-clipboard 
    brightnessctl 
    pamixer 
    playerctl 
    xdg-desktop-portal 
    xdg-desktop-portal-wlr 
    polkit 
    greetd 
    tuigreet 
    NetworkManager 
    NetworkManager-wifi 
    NetworkManager-tui 
    pipewire 
    pipewire-pulseaudio 
    wireplumber 
    fontconfig 
    libxkbcommon
    zsh
    bluez
    bluez-tools
    cargo 
    rust 
    rust-analyzer 
    gcc 
    gcc-c++ 
    make 
    pkgconf-pkg-config 
    wayland-devel 
    fontconfig-devel 
    libxkbcommon-devel 
    dbus-devel
)

dnf5 install --setopt=install_weak_deps=False -y "${DESKTOP_PACKAGES[@]}"

RUST_PACKAGES=(
    kickoff
    bluetui
)

cargo install "${RUST_PACKAGES[@]}" --locked --root /usr

# Install Ubuntu Nerd Fonts
dnf5 install -y curl xz

mkdir -p /usr/share/fonts/nerd-fonts/UbuntuMono

curl -L \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.tar.xz \
  -o /tmp/UbuntuMono.tar.xz

tar -xf /tmp/UbuntuMono.tar.xz \
  -C /usr/share/fonts/nerd-fonts/UbuntuMono

fc-cache -fv

# --- enable services ---
systemctl enable greetd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service

# --- set zsh as default ---
while IFS=: read -r user _ uid _ _ home shell; do
    if [[ "$uid" -ge 1000 && "$user" != "nobody" ]]; then
        usermod -s /usr/bin/zsh "$user"
    fi
done < /etc/passwd

dnf5 clean all
