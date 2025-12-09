#!/bin/bash
xset -dpms # disable DPMS (Energy Star) features.
xset s off # disable screen saver
xset s noblank # don't blank the video device
unclutter &
matchbox-window-manager &
#openbox
while true; do
  if sudo ping -c 1 -w 180 nvv.de | grep -o "time"; then
    if ps -a | grep -o "firefox"; then
                        sleep 90
                else
                        firefox --kiosk "DISPLAY_URL" & disown
                fi
        else
                sleep 10;
        fi
done
