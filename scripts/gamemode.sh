#!/bin/bash

OPTS="Game Mode
Normal Mode"

SEL=$(echo "$OPTS" | fzf --layout=reverse)

case $SEL in
Game\ Mode)
  mmsg dispatch
  notify-send "Game Mode Enabled"
  ;;
Normal\ Mode)
  mmsg dispatch reload_config
  notify-send "Back To Normal Mode"
  ;;
esac
