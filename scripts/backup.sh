#!/bin/bash

HDD_PATH="/run/media/$USER/Seagate Basic"
BACKUP_DIR="$HDD_PATH/Backup_$(date +%d-%m-%Y)"
SOURCES=(
    "$HOME/Pictures"
    "$HOME/Documents"
    "$HOME/Videos"
    "$HOME/.config"
    "$HOME/Docker"
    "$HOME/Sync"
    "$HOME/.fonts"
    "$HOME/.sklauncher"
    "$HOME/.ssh"
    "$HOME/repos"
    "$HOME/OBS"
    "$HOME/Seanime"
)

notify-send "Backup started. Relax bruv"
mkdir -p "$BACKUP_DIR"

rsync -avh --progress "${SOURCES[@]}" "$BACKUP_DIR/"

sync

notify-send "ggz backup done"
echo done
exit 0
