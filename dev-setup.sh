#!/bin/bash

. /etc/os-release

ID_LIKE=${ID_LIKE:-$ID}

echo "Your distro is based on $ID_LIKE."

PACKAGES_FILE="./packages/packages-to-install"

if [ ! -f "$PACKAGES_FILE" ]; then
    echo "Packages file not found!"
    exit 1
fi

# Detect package manager
if echo "$ID_LIKE" | grep -Eq "debian|ubuntu"; then
    PM="apt"
elif echo "$ID_LIKE" | grep -Eq "arch"; then
    PM="pacman"
elif echo "$ID_LIKE" | grep -Eq "fedora|rhel"; then
    PM="dnf"
elif echo "$ID_LIKE" | grep -Eq "suse"; then
    PM="zypper"
else
    echo "Sorry, your distro is not compatible."
    exit 1
fi

echo "Using package manager: $PM"

# Read packages (ignore comments and empty lines)
mapfile -t PACKAGES < <(grep -vE '^#|^$' "$PACKAGES_FILE")

echo "Installing: ${PACKAGES[*]}"

# Install packages
case $PM in
    apt)
        sudo apt update
        sudo apt install -y "${PACKAGES[@]}"
        ;;
    pacman)
        sudo pacman -Sy --noconfirm "${PACKAGES[@]}"
        ;;
    dnf)
        sudo dnf install -y "${PACKAGES[@]}"
        ;;
    zypper)
        sudo zypper install -y "${PACKAGES[@]}"
        ;;
esac

echo "Packages are now installed! Enjoy your dev pack."