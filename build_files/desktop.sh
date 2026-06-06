#!/usr/bin/bash
set -ouex pipefail

dnf5 install --setopt=install_weak_deps=False -y \
    sway \
    swaybg \
    swaylock \
    swayidle \
    alacritty \
    i3status \
    kanshi \
    dunst \
    grim \
    slurp \
    wl-clipboard \
    brightnessctl \
    pamixer \
    playerctl \
    xdg-desktop-portal \
    xdg-desktop-portal-wlr \
    polkit \
    greetd \
    tuigreet \
    NetworkManager \
    NetworkManager-wifi \
    NetworkManager-tui \
    pipewire \
    pipewire-pulseaudio \
    wireplumber \
    fontconfig \
    libxkbcommon

# kickoff is built in your rust-builder stage and copied into the final image
# via Containerfile:
# COPY --from=rust-builder /out/bin/kickoff /usr/local/bin/kickoff

systemd-sysusers /usr/lib/sysusers.d/greetd.conf
systemd-tmpfiles --create /usr/lib/tmpfiles.d/greetd.conf

# Install Ubuntu Nerd Fonts
dnf5 install -y curl xz

mkdir -p /usr/share/fonts/nerd-fonts/UbuntuMono

curl -L \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.tar.xz \
  -o /tmp/UbuntuMono.tar.xz

tar -xf /tmp/UbuntuMono.tar.xz \
  -C /usr/share/fonts/nerd-fonts/UbuntuMono

fc-cache -fv

systemctl enable greetd.service
systemctl enable NetworkManager.service

dnf5 clean all
