#!/bin/bash

OPTS="Laptop Only
External Only
Both On"

DISPLAYCONF=$HOME/.config/mango/monitors.conf

SEL=$(echo "$OPTS" | fzf --layout=reverse)

case $SEL in
Laptop\ Only)
  echo 'monitorrule=name:HDMI-A-1,width:1920,height:1080,refresh:143.996994,x:2000,y:0,rr:0,disable:1
monitorrule=name:eDP-1,width:1920,height:1080,refresh:120.212997,x:0,y:0,rr:0,disable:0' >$DISPLAYCONF
  mmsg dispatch wakeup_monitor,eDP-1
  mmsg dispatch sleep_monitor,HDMI-A-1
  mmsg dispatch reload_config
  notify-send "display set to laptop-only"
  ;;
External\ Only)
  echo 'monitorrule=name:HDMI-A-1,width:1920,height:1080,refresh:143.996994,x:2000,y:0,rr:0,disable:0
monitorrule=name:eDP-1,width:1920,height:1080,refresh:120.212997,x:0,y:0,rr:0,disable:1' >$DISPLAYCONF
  mmsg dispatch wakeup_monitor,HDMI-A-1
  mmsg dispatch sleep_monitor,eDP-1
  mmsg dispatch reload_config
  notify-send "display set to External-only"
  ;;
Both\ On)
  echo 'monitorrule=name:HDMI-A-1,width:1920,height:1080,refresh:143.996994,x:2000,y:0,rr:0,disable:0
monitorrule=name:eDP-1,width:1920,height:1080,refresh:120.212997,x:0,y:0,rr:0,disable:0' >$DISPLAYCONF
  mmsg dispatch wakeup_monitor,HDMI-A-1
  mmsg dispatch wakeup_monitor,eDP-1
  mmsg dispatch reload_config
  notify-send "display set to Both Screen On"
  ;;
esac
mmsg dispatch reload_config
