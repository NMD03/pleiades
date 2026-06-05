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
    polkit-gnome-authentication-agent-1
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

systemctl enable greetd.service
systemctl enable NetworkManager.service

install -Dm644 /ctx/files/greetd-config.toml /etc/greetd/config.toml
install -Dm644 /ctx/files/sway-config /etc/sway/config

dnf5 clean all
