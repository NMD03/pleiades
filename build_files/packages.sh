#!/usr/bin/bash

set -ouex pipefail

# --- import helper functions ---
source /ctx/helper.sh

# --- Handle COPR repos
COPR_REPOS=(
    # eddsalkield/swaylock-effects
)

for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr enable "$repo"
done

# --- define packages to be installed ---
LAYERED_PACKAGES=(
    eza
    neovim
    ripgrep
    jq
    yq
    make
    gcc
    gcc-c++
    fd-find
    nodejs
    npm
    fzf
    stow
    htop
    fastfetch
    flatpak
    incus
    incus-client
    incus-tools
    incus-selinux
    shadow-utils
    # swaylock-effects
)

dnf5 install --setopt=install_weak_deps=False -y "${LAYERED_PACKAGES[@]}"

# --- disable COPR repos again ---
for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr disable "$repo"
done

# --- remove packages ---
REMOVED_PACKAGES=()

if [[ "${#REMOVED_PACKAGES[@]}" -gt 0 ]]; then
    dnf5 -y remove "${REMOVED_PACKAGES[@]}"
fi

# --- enable services ---
systemctl enable incus.service
getent group incus-admin || groupadd -r incus-admin
