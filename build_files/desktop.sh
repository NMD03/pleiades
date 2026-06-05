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

getent passwd greeter || useradd -r -M -s /sbin/nologin greeter

systemctl enable greetd.service
systemctl enable NetworkManager.service

dnf5 clean all
