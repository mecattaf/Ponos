#!/bin/bash

mkdir -p /var/home/$USER/.distrobox
mkdir -p /var/home/$USER/.icons
mkdir -p /var/home/$USER/.themes

mkdir -p /var/home/$USER/.local/share/wallpapers
mkdir -p /var/home/$USER/.local/share/base16
mkdir -p /var/home/$USER/.local/share/fonts

#flatpak override --filesystem=/var/home/$USER/.icons
#flatpak override --filesystem=/var/home/$USER/.themes

bibata=https://github.com/ful1e5/Bibata_Cursor/releases/download/v1.1.2/Bibata-Modern.tar.gz
bibataExtra=https://github.com/mecattaf/cursors/releases/download/v1.0.0/Bibata-Modern.tar.gz
fonts=https://github.com/mecattaf/fonts/archive/refs/tags/nerd.tar.gz
wallpapers=https://github.com/mecattaf/wallpapers/archive/refs/tags/plants.tar.gz
base16=https://github.com/mecattaf/base16/archive/refs/tags/flavours.tar.gz
gtk=https://github.com/mecattaf/gtk/archive/refs/tags/0.9.0.tar.gz

curl -o bibata.tar.gz -L "$bibata"
tar -xf bibata.tar.gz -C /var/home/$USER/.icons/
rm bibata.tar.gz

curl -o bibataExtra.tar.gz -L "$bibataExtra"
tar -xf bibataExtra.tar.gz -C /var/home/$USER/.icons/
mv /var/home/$USER/.icons/Bibata-Modern/* /var/home/$USER/.icons/
rm -rf /var/home/$USER/.icons/Bibata-Modern/
rm bibataExtra.tar.gz

curl -o fonts.tar.gz -L "$fonts"
tar -xf fonts.tar.gz -C /var/home/$USER/.local/share/fonts
mv /var/home/$USER/.local/share/fonts/fonts-nerd/* /var/home/$USER/.local/share/fonts/
rm -rf /var/home/$USER/.local/share/fonts/fonts-nerd/
rm fonts.tar.gz
fc-cache -v

curl -o wallpapers.tar.gz -L "$wallpapers"
tar -xf wallpapers.tar.gz -C /var/home/$USER/.local/share/wallpapers
mv /var/home/$USER/.local/share/wallpapers/wallpapers-plants/* /var/home/$USER/.local/share/wallpapers/
rm -rf /var/home/$USER/.local/share/wallpapers/wallpapers-plants
rm wallpapers.tar.gz

curl -o base16.tar.gz -L "$base16"
tar -xf base16.tar.gz -C /var/home/$USER/.local/share/base16
mv /var/home/$USER/.local/share/base16/base16-flavours/* /var/home/$USER/.local/share/base16/
rm -rf /var/home/$USER/.local/share/base16/base16-flavours/ 
rm base16.tar.gz

curl -o Base16.tar.gz -L "$gtk"
tar -xf Base16.tar.gz -C /var/home/$USER/.themes/
mv /var/home/$USER/.themes/gtk-0.9.0 /var/home/$USER/.themes/Base16
rm Base16.tar.gz

