#!/bin/bash

OPTS="Shutdown
Sleep
Logout
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
  systemctl
  ;;
Reboot)
  systemctl reboot
  ;;
esac
