#!/bin/bash

APP=(
  "/usr/share/applications/"
  "$HOME/.local/share/applications/"
)

SELECTED=$(find "${APP[@]}" -maxdepth 1 -name "*.desktop" | fzf --prompt="Search:" --layout=reverse)

xdg-open "$SELECTED"
sleep 1
