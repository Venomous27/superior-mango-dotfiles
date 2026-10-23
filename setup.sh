#!/bin/bash

echo "taking backup of your stuff"
mkdir -p ~/old-configs-backup
[ -e ~/.config/mango ] && mv ~/.config/mango ~/old-configs-backup/
[ -e ~/.config/fish ] && mv ~/.config/fish ~/old-configs-backup/
[ -e ~/.config/fastfetch ] && mv ~/.config/fastfetch ~/old-configs-backup/
[ -e ~/.config/nvim ] && mv ~/.config/nvim ~/old-configs-backup/
[ -e ~/.config/rofi ] && mv ~/.config/rofi ~/old-configs-backup/
[ -e ~/.config/pipewire ] && mv ~/.config/pipewire ~/old-configs-backup/
[ -e ~/.config/swayidle ] && mv ~/.config/swayidle ~/old-configs-backup/
[ -e ~/.config/swaylock ] && mv ~/.config/swaylock ~/old-configs-backup/
[ -e ~/.themes ] && mv ~/.themes ~/old-configs-backup/

echo "Updating and installing stuff from official repo"
sudo pacman -Syu awww btop fish foot fzf grim slurp satty mpv neovim rofi rofi-emoji swayidle swaylock thunar thunar-archive-plugin stow gwenview fastfetch --noconfirm --needed

echo "Installing important stuff"
sudo pacman -S base-devel git networkmanager wireplumber brightnessctl pavucontrol pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse xdg-desktop-portal-wlr xdg-utils --noconfirm --needed

echo "Setting up yay"
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd ~

echo "Installing stuff from AUR"
yay -S mangowm-git wayle-bin python-pywal clipse elio --noconfirm

#echo "Installing Venom's need"
#yay -s obs-multi-rtmp ttf-ms-win10-auto --noconfirm
#sudo pacman -S obs-studio python syncthing zed zen-browser-bin localsend --noconfirm --needed

echo "Stowing configs"
cd ~/superior-mango-dotfiles
stow -v -R mango foot fastfetch elio gtk-themes pywal pipewire wayle swayidle swaylock rofi nvim

echo "Making the scripts executable"
chmod +x ~/superior-mango-dotfiles/scripts/monitor.sh
chmod +x ~/superior-mango-dotfiles/scripts/powermenu.sh
chmod +x ~/superior-mango-dotfiles/scripts/wallpaper.sh
chmod +x ~/.config/mango/layout-switcher.sh


#Reference
#https://github.com/olingern/arch-dotfiles/blob/master/setup.sh
#https://github.com/vmax1g/old-dotfiles/blob/main/install.sh

#Readme for script
#> [!WARNING]
#> This script was tested on a **fresh install** of CachyOS. It is strongly recommended to review [setup.sh](setup.sh) before running it so you understand what changes will be made.

#> [!CAUTION]
#> I also checked it on a working pc (configured) and it gave errors. I will not be held responsible for any damage or other stuff—run it at your own risk.

#Some packages have been commented out based on personal preference. If you already have an AUR helper installed, remember to comment out that section.

#To run the script:

#```bash
#git clone https://github.com/Venomous27/superior-mango-dotfiles.git ~/superior-mango-dotfiles
#cd ~/superior-mango-dotfiles
#chmod +x setup.sh
#./setup.sh
#```
