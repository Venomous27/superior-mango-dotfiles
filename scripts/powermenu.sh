#!/bin/bash

OPTS="Shutdown
Sleep
Logout
Lock
Reboot"

SEL=$(echo "$OPTS" | fzf --layout=reverse --border)

case $SEL in
Shutdown)
  systemctl poweroff
  ;;
Sleep)
  systemctl suspend
  ;;
Logout)
    loginctl terminate-user $USER
  ;;
Reboot)
  systemctl reboot
  ;;
Lock)
  swaylock
  ;;
esac
