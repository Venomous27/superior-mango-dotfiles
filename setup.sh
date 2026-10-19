#!/bin/bash

echo "Updating and installing stuff from official repo"
sudo pacman -Syu awww btop fish foot fzf grim slurp satty mpv neovim rofi rofi-emoji swayidle swaylock thunar thunar-archive-plugin stow gwenview --noconfirm --needed

echo "Installing important stuff"
sudo pacman -S networkmanager pavucontrol pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse xdg-desktop-portal-wlr xdg-utils --noconfirm --needed

echo "Setting up yay"
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd ~

echo "Installing stuff from AUR"
yay -S mangowm-git wayle-bin python-pywal clipse elio

#echo "Installing Venom's need"
#yay -s obs-multi-rtmp ttf-ms-win10-auto
#sudo pacman -S obs-studio python syncthing zed zen-browser-bin localsend --noconfirm --needed

echo "Stowing configs"
cd ~/superior-mango-dotfiles
stow mango foot fastfetch elio gtk-themes pywal pipewire wayle swayidle rofi nvim

echo "Making the scripts executable"
chmod +x ~/superior-mango-dotfiles/scripts/monitor.sh
chmod +x ~/superior-mango-dotfiles/scripts/powermenu.sh
chmod +x ~/superior-mango-dotfiles/scripts/wallpaper.sh
chmod +x ~/.config/mango/layout-switcher.sh


#Reference
#https://github.com/olingern/arch-dotfiles/blob/master/setup.sh
#https://github.com/vmax1g/old-dotfiles/blob/main/install.sh
