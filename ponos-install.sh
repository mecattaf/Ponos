#!/bin/bash

set -eu

[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} 

SCRIPTS=./scripts
source $SCRIPTS/common

echo "Enabling FlatHub.."
flatpak remote-modify --enable flathub
echo "Installing Flatpak(s)..."
flatpak_install_remote flathub https://flathub.org/repo/flathub.flatpakrepo

# Configure Flatpak automatic upgrades
source $SCRIPTS/flatpak_automatic_updates

###### systemctl mask --now rpm-ostree-countme.timer
systemctl enable rpm-ostree-countme.timer

echo "Checking base layer..."
while ! is_ostree_idle; do
    echo "Waiting for rpm-ostree..."
    sleep 5
done

if rpm-ostree override remove firefox > /dev/null; then
    echo "Removed Firefox from base layer."
fi

flatpak_install flathub applications.list

flatpak override --user --filesystem=~/.local/share/applications:create --filesystem=~/.local/share/icons:create com.google.Chrome


rpm-ostree --idempotent install  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm mozilla-openh264 gstreamer1-plugin-openh264

if [ ! -e /etc/yum.repos.d/tailscale.repo ]; then
    echo "Installing Tailscale repo..."
    sudo curl -s https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo > /dev/null
    # Disable repo_gpgcheck, which doesn't work on Silverblue 36+
    sudo sed -i 's/repo_gpgcheck=1/repo_gpgcheck=0/' /etc/yum.repos.d/tailscale.repo
fi

echo "Installing layered packages..."
cat layered-packages.list | rpm-ostree --idempotent install `xargs`

flatpak uninstall --system --delete-data org.gnome.Calculator org.gnome.Calendar org.gnome.Connections org.gnome.Contacts org.gnome.Logs org.gnome.Maps org.gnome.Weather org.gnome.baobab

mkdir -p /var/home/$USER/.icons
mkdir -p /var/home/$USER/.themes
mkdir -p /var/home/$USER/.local/share/wallpapers
mkdir -p /var/home/$USER/.local/share/base16
mkdir -p /var/home/$USER/.local/share/fonts

#flatpak override --filesystem=/var/home/$USER/.icons
#flatpak override --filesystem=/var/home/$USER/.themes
#flatpak override com.google.Chrome --filesystem=$HOME/.themes
#flatpak override --env=GTK_THEME=Base16

echo "Reboot your system with: systemctl reboot"
exit 0;
