#!/bin/bash

#IMG=$(find ~/Pictures/Wallpapers/ -type f | sed "s|$HOME/Pictures/Wallpapers/||" | fzf --layout=reverse)

IMG=$(find ~/Pictures/Wallpapers/ -type f | sed "s|$HOME/Pictures/Wallpapers/||" | fzf --layout=reverse --preview="chafa --clear $HOME/Pictures/Wallpapers/{}" --preview-window='right:40%')

if [ "$IMG" == "" ]; then exit 1; fi

awww img ~/Pictures/Wallpapers/$IMG --transition-type fade --transition-duration 1

wal -i ~/Pictures/Wallpapers/$IMG

setsid wayle panel restart </dev/null >/dev/null 2>&1 
