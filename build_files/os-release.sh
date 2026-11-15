#!/usr/bin/bash
# Brand the image as Pleiades. ID/VERSION_ID stay "fedora"/"45" on purpose:
# dnf, bootc-image-builder and other tools use them to find repos.
set -ouex pipefail

OS_RELEASE=/usr/lib/os-release # /etc/os-release links here

set_field() {
    local key=$1 value=$2
    if grep -q "^${key}=" "$OS_RELEASE"; then
        sed -i "s|^${key}=.*|${key}=\"${value}\"|" "$OS_RELEASE"
    else
        echo "${key}=\"${value}\"" >> "$OS_RELEASE"
    fi
}

set_field NAME "Pleiades"
set_field PRETTY_NAME "Pleiades Linux"
set_field DEFAULT_HOSTNAME "pleiades"
