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
    # VMs: Incus (`incus launch --vm`) and plain QEMU
    qemu-kvm-core
    qemu-system-x86-core
    edk2-ovmf # UEFI firmware
    incus-agent # `incus exec`/file transfer inside VMs
    swtpm # virtual TPM
    virtiofsd # share host folders into VMs
    qemu-img
    qemu-ui-gtk # QEMU window on the desktop
    qemu-ui-opengl
    qemu-audio-pipewire
    container-selinux
    docker-compose # for `podman compose`, talks to podman.socket
    shadow-utils
    openssl-devel 
    pkgconf-pkg-config 
    perl
    gnome-keyring
    gnome-keyring-pam # unlocks the keyring at greetd login (see /usr/lib/pam.d/greetd)
    libsecret
    nss-tools # certutil: add CAs to ~/.pki/nssdb for Chromium/Electron apps
    mate-polkit # password prompts for admin actions in the sway session
    tuned-ppd # power profiles (powerprofilesctl), backed by tuned
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
systemctl enable tuned.service tuned-ppd.service
getent group incus-admin || groupadd -r incus-admin
