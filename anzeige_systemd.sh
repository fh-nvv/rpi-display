#!/bin/bash

xset s off
xset -dpms
xset s noblank

unclutter &

matchbox-window-manager &

# WICHTIG: exec damit Session sauber bleibt
exec chromium --start-fullscreen "DISPLAY_URL"
